//
//  ARGalleryView.swift
//  baby
//
import SwiftUI
import ARKit
import RealityKit
import SwiftData

struct ARGalleryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PhotoCard.createdAt, order: .reverse) private var cards: [PhotoCard]
    @Environment(\.dismiss) private var dismiss

    @State private var statusMessage  = "Inizializzazione AR..."
    @State private var placedCount    = 0
    @State private var totalSaved     = 0
    @State private var showResetAlert = false

    var body: some View {
        ZStack {
            if ARWorldTrackingConfiguration.isSupported {
                ARGalleryContainer(
                    cards: cards,
                    statusMessage: $statusMessage,
                    placedCount: $placedCount,
                    totalSaved: $totalSaved
                )
                .ignoresSafeArea()

                VStack {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2).foregroundStyle(.white)
                                .background(Circle().fill(.black.opacity(0.5)))
                        }
                        Spacer()
                        VStack(spacing: 3) {
                            Text(statusMessage)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                            if totalSaved > 0 {
                                Text("\(placedCount)/\(totalSaved) card caricate")
                                    .font(.system(size: 10))
                                    .foregroundStyle(
                                        placedCount == totalSaved ? .green : .yellow
                                    )
                            }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(.ultraThinMaterial,
                                    in: RoundedRectangle(cornerRadius: 12))
                        .environment(\.colorScheme, .dark)
                        Spacer()
                        Button { showResetAlert = true } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title2).foregroundStyle(.white)
                                .background(Circle().fill(.black.opacity(0.5)))
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 8)

                    Spacer()

                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.white.opacity(0.6))
                        Text("Le card appaiono nelle posizioni salvate")
                            .font(.caption).foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
                    .background(.ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 14))
                    .environment(\.colorScheme, .dark)
                    .padding(.horizontal, 20).padding(.bottom, 40)
                }

            } else {
                ZStack {
                    Color(hex: "040816").ignoresSafeArea()
                    VStack(spacing: 20) {
                        Image(systemName: "arkit")
                            .font(.system(size: 60)).foregroundStyle(.secondary)
                        Text("AR non disponibile")
                            .font(.title2.bold()).foregroundStyle(.white)
                        Text("Usa un dispositivo fisico con iOS 17+")
                            .foregroundStyle(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                        Button { dismiss() } label: {
                            Text("Chiudi").foregroundStyle(.white)
                                .padding(.horizontal, 24).padding(.vertical, 12)
                                .background(Capsule().fill(Color(hex: "e94560")))
                        }
                    }.padding(40)
                }
            }
        }
        .alert("Reset Galleria AR", isPresented: $showResetAlert) {
            Button("Annulla", role: .cancel) {}
            Button("Reset tutto", role: .destructive) {
                ARCardPersistence.shared.clearSavedData()
                placedCount   = 0
                totalSaved    = 0
                statusMessage = "Posizioni rimosse."
            }
        } message: { Text("Rimuovere tutte le posizioni salvate?") }
    }
}

// MARK: - UIViewRepresentable

struct ARGalleryContainer: UIViewRepresentable {
    let cards: [PhotoCard]
    @Binding var statusMessage: String
    @Binding var placedCount: Int
    @Binding var totalSaved: Int

    func makeCoordinator() -> ARGalleryCoordinator {
        ARGalleryCoordinator(cards: cards,
                             statusMessage: $statusMessage,
                             placedCount: $placedCount,
                             totalSaved: $totalSaved)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.debugOptions = [.showFeaturePoints]
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator
        context.coordinator.startSession()
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

// MARK: - Coordinator

class ARGalleryCoordinator: NSObject, ARSessionDelegate {
    let cards: [PhotoCard]
    weak var arView: ARView?
    @Binding var statusMessage: String
    @Binding var placedCount: Int
    @Binding var totalSaved: Int

    private let persistence = ARCardPersistence.shared
    private var loaded = false

    init(cards: [PhotoCard],
         statusMessage: Binding<String>,
         placedCount: Binding<Int>,
         totalSaved: Binding<Int>) {
        self.cards          = cards
        self._statusMessage = statusMessage
        self._placedCount   = placedCount
        self._totalSaved    = totalSaved
    }

    func startSession() {
        guard let arView else { return }
        let config = ARWorldTrackingConfiguration()
        config.planeDetection       = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        // Gallery: reset sempre → .normal veloce, piazza con coordinate salvate
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        DispatchQueue.main.async {
            switch camera.trackingState {
            case .notAvailable:
                self.statusMessage = "Tracking non disponibile"
            case .limited(let r):
                switch r {
                case .initializing:
                    self.statusMessage = "Inizializzazione AR..."
                case .relocalizing:
                    self.statusMessage = "Rilocalizzando..."
                case .excessiveMotion:
                    self.statusMessage = "Rallenta il movimento"
                case .insufficientFeatures:
                    self.statusMessage = "Aggiungi luce all'ambiente"
                @unknown default:
                    self.statusMessage = "Tracking limitato"
                }
            case .normal:
                if !self.loaded {
                    self.loaded = true
                    self.placeAllCards()
                }
            }
        }
    }

    private func placeAllCards() {
        guard let arView else { return }

        let allTransforms = persistence.loadAllTransforms()
        let cardsToPlace  = cards.filter {
            allTransforms[$0.id.uuidString] != nil
        }

        DispatchQueue.main.async { self.totalSaved = cardsToPlace.count }

        guard !cardsToPlace.isEmpty else {
            DispatchQueue.main.async {
                self.statusMessage = "Nessuna card salvata. Usa AR dalla card."
            }
            return
        }

        DispatchQueue.main.async {
            self.statusMessage = "Posizionamento \(cardsToPlace.count) card..."
        }

        for card in cardsToPlace {
            guard let transform = persistence.loadTransform(for: card) else { continue }

            let anchorName   = persistence.anchorName(for: card)
            let arAnchor     = ARAnchor(name: anchorName, transform: transform)
            arView.session.add(anchor: arAnchor)

            let anchorEntity = AnchorEntity(anchor: arAnchor)

            Task { @MainActor in
                let polaroid = await buildPolaroid(for: card)
                anchorEntity.addChild(polaroid)
                arView.scene.addAnchor(anchorEntity)
                self.placedCount += 1
                if self.placedCount == self.totalSaved {
                    self.statusMessage = "Tutte le card caricate ✓"
                } else {
                    self.statusMessage = "\(self.placedCount)/\(self.totalSaved) card caricate"
                }
            }
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.statusMessage = "Errore: \(error.localizedDescription)"
        }
    }
}

