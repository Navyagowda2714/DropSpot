//
//  ARCardView.swift
//  baby
//
//  Created by Navyashree Byregowda on 01/04/2026.
import SwiftUI
import ARKit
import RealityKit

struct ARCardView: View {
    let card: PhotoCard
    @Environment(\.dismiss) private var dismiss

    @State private var statusMessage  = "Inizializzazione AR..."
    @State private var cardPlaced     = false
    @State private var showResetAlert = false

    var body: some View {
        ZStack {
            if ARWorldTrackingConfiguration.isSupported {
                ARPhotoCardContainer(
                    card: card,
                    statusMessage: $statusMessage,
                    cardPlaced: $cardPlaced
                )
                .ignoresSafeArea()

                VStack {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2).foregroundStyle(.white)
                                .background(Circle().fill(.black.opacity(0.4)))
                        }
                        Spacer()
                        Text(statusMessage)
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            .background(.ultraThinMaterial,
                                        in: RoundedRectangle(cornerRadius: 12))
                            .environment(\.colorScheme, .dark)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button { showResetAlert = true } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title2).foregroundStyle(.white)
                                .background(Circle().fill(.black.opacity(0.4)))
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 8)

                    Spacer()

                    if !cardPlaced {
                        Image(systemName: "scope")
                            .font(.system(size: 44))
                            .foregroundStyle(.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.5), radius: 4)
                    }

                    Spacer()

                    if cardPlaced {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Card posizionata e salvata!")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(.ultraThinMaterial,
                                    in: RoundedRectangle(cornerRadius: 14))
                        .environment(\.colorScheme, .dark)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        Text("Punta il mirino su una superficie e tocca")
                            .font(.caption).foregroundStyle(.white.opacity(0.7))
                            .padding(.bottom, 40)
                    }
                }
                .animation(.spring(response: 0.4), value: cardPlaced)

            } else {
                arUnavailableView
            }
        }
        .alert("Reset posizione", isPresented: $showResetAlert) {
            Button("Annulla", role: .cancel) {}
            Button("Reset", role: .destructive) {
                ARCardPersistence.shared.removeTransform(for: card)
                cardPlaced    = false
                statusMessage = "Posizione rimossa. Tocca per riposizionare."
            }
        } message: { Text("Rimuovere la posizione salvata?") }
    }

    var arUnavailableView: some View {
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

// MARK: - UIViewRepresentable

struct ARPhotoCardContainer: UIViewRepresentable {
    let card: PhotoCard
    @Binding var statusMessage: String
    @Binding var cardPlaced: Bool

    func makeCoordinator() -> ARPhotoCoordinator {
        ARPhotoCoordinator(card: card,
                           statusMessage: $statusMessage,
                           cardPlaced: $cardPlaced)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.debugOptions = [.showFeaturePoints]
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator
        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(ARPhotoCoordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tap)
        context.coordinator.startSession()
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

// MARK: - Coordinator

class ARPhotoCoordinator: NSObject, ARSessionDelegate {
    let card: PhotoCard
    weak var arView: ARView?
    @Binding var statusMessage: String
    @Binding var cardPlaced: Bool

    private var placed = false
    private var currentAnchorEntity: AnchorEntity?
    private let persistence = ARCardPersistence.shared

    init(card: PhotoCard,
         statusMessage: Binding<String>,
         cardPlaced: Binding<Bool>) {
        self.card           = card
        self._statusMessage = statusMessage
        self._cardPlaced    = cardPlaced
    }

    // MARK: - Sessione — reset SEMPRE, niente WorldMap

    func startSession() {
        guard let arView else { return }
        let config = ARWorldTrackingConfiguration()
        config.planeDetection       = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    // MARK: - Tap → piazza sul piano

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let arView, !placed else { return }

        let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)

        let planeResults = arView.raycast(
            from: center,
            allowing: .existingPlaneGeometry,
            alignment: .any
        )
        let results = planeResults.isEmpty
            ? arView.raycast(from: center, allowing: .estimatedPlane, alignment: .any)
            : planeResults

        guard let hit = results.first else {
            statusMessage = "Nessun piano rilevato. Continua a scansionare."
            return
        }

        placeCard(at: hit.worldTransform, in: arView)
    }

    // MARK: - Piazza card

    private func placeCard(at transform: simd_float4x4, in arView: ARView) {
        currentAnchorEntity?.removeFromParent()
        placed = true

        let arAnchor     = ARAnchor(name: persistence.anchorName(for: card),
                                    transform: transform)
        arView.session.add(anchor: arAnchor)

        let anchorEntity = AnchorEntity(anchor: arAnchor)
        currentAnchorEntity = anchorEntity

        Task { @MainActor in
            let polaroid = await buildPolaroid(for: self.card)
            anchorEntity.addChild(polaroid)
            arView.scene.addAnchor(anchorEntity)
            self.cardPlaced    = true
            self.statusMessage = "Card posizionata!"
        }

        // Salva solo la trasformazione di questa card
        persistence.saveTransform(transform, for: card)
    }

    // MARK: - Tracking state

    func session(_ session: ARSession,
                 cameraDidChangeTrackingState camera: ARCamera) {
        guard !placed else { return }
        DispatchQueue.main.async {
            switch camera.trackingState {
            case .notAvailable:
                self.statusMessage = "Tracking non disponibile"
            case .limited(let r):
                switch r {
                case .initializing:
                    self.statusMessage = "Inizializzazione... muovi il telefono lentamente"
                case .relocalizing:
                    self.statusMessage = "Rilocalizzando..."
                case .excessiveMotion:
                    self.statusMessage = "Troppo movimento, rallenta"
                case .insufficientFeatures:
                    self.statusMessage = "Punta su una superficie con dettagli"
                @unknown default:
                    self.statusMessage = "Tracking limitato"
                }
            case .normal:
                // Appena .normal → mostra subito la card già piazzata se esiste
                if let savedTransform = self.persistence.loadTransform(for: self.card) {
                    self.placeCard(at: savedTransform, in: self.arView!)
                    self.statusMessage = "Card ripristinata!"
                } else {
                    self.statusMessage = "Punta il mirino su una superficie e tocca"
                }
            }
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.statusMessage = "Errore AR: \(error.localizedDescription)"
        }
    }
}

