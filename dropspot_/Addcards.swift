//
//  Addcards.swift
//  baby
//
//  Created by Gennaro Biagino on 01/04/2026.
//

//
//  Addcards.swift
//  baby
//
//  Created by Gennaro Biagino on 01/04/2026.
//

import SwiftUI
import PhotosUI
import SwiftData
import CoreLocation

struct AddCardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var locationManager = LocationManager()

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var cardTitle       = ""
    @State private var selectedSize: CardSize = .medium
    @State private var showCamera      = false
    @State private var isProcessing    = false
    @State private var showSavedBanner = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0d1b2a").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        imagePicker
                        if selectedImage != nil {
                            titleField
                            sizePicker
                            cardPreview
                            locationStatus
                            saveButton
                        }
                    }
                    .padding(20)
                }

                // Success banner
                if showSavedBanner {
                    VStack {
                        Spacer()
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Card salvata!")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(
                            Capsule().fill(Color(hex: "1e2d4a"))
                                .overlay(Capsule().stroke(.white.opacity(0.1), lineWidth: 1))
                        )
                        .shadow(color: .black.opacity(0.4), radius: 12)
                        .padding(.bottom, 30)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("Nuova Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showCamera) { CameraView(image: $selectedImage) }
            .onAppear { locationManager.requestLocation() }
        }
    }

    // MARK: - Location status row

    var locationStatus: some View {
        HStack(spacing: 10) {
            Image(systemName: locationManager.currentCoordinate != nil
                  ? "mappin.circle.fill" : "mappin.slash.circle.fill")
                .foregroundStyle(locationManager.currentCoordinate != nil
                                 ? Color(hex: "e94560") : .white.opacity(0.35))
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text("Posizione")
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(1.2)
                Text(locationManager.currentCoordinate != nil
                     ? "GPS acquisito — card appuntata sulla mappa"
                     : "GPS non disponibile — la card non avrà posizione")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(locationManager.currentCoordinate != nil ? 0.7 : 0.4))
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12).fill(Color(hex: "1e2d4a"))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.08), lineWidth: 1))
        )
    }

    // MARK: - Image picker

    var imagePicker: some View {
        VStack(spacing: 16) {
            if let img = selectedImage {
                Image(uiImage: img)
                    .resizable().scaledToFill().frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.15), lineWidth: 1))
                    .shadow(color: .black.opacity(0.5), radius: 12)
            }
            HStack(spacing: 12) {
                Button { showCamera = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                        Text("Fotocamera")
                    }
                    .font(.subheadline.bold()).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "e94560")))
                }
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.fill")
                        Text("Galleria")
                    }
                    .font(.subheadline.bold()).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "1e3a5f")))
                }
                .onChange(of: selectedPhotoItem) { loadImage() }
            }
        }
    }

    var titleField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NOME CARD")
                .font(.caption.bold()).foregroundStyle(.white.opacity(0.5)).tracking(1.5)
            TextField("Es. Vacanza Estate 2025", text: $cardTitle)
                .foregroundStyle(.white).padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color(hex: "1e2d4a"))
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.1), lineWidth: 1))
                )
        }
    }

    var sizePicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DIMENSIONE CARD")
                .font(.caption.bold()).foregroundStyle(.white.opacity(0.5)).tracking(1.5)
            HStack(spacing: 10) {
                ForEach(CardSize.allCases, id: \.self) { size in
                    SizeOptionButton(size: size, isSelected: selectedSize == size) {
                        withAnimation(.spring(response: 0.3)) { selectedSize = size }
                    }
                }
            }
        }
    }

    var cardPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ANTEPRIMA")
                .font(.caption.bold()).foregroundStyle(.white.opacity(0.5)).tracking(1.5)
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(Color(hex: "101827"))
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.08), lineWidth: 1))
                if let img = selectedImage {
                    let dims = selectedSize.dimensions
                    VStack(spacing: 0) {
                        Image(uiImage: img).resizable().scaledToFill()
                            .frame(
                                width:  min(dims.width, UIScreen.main.bounds.width - 80),
                                height: min(dims.height * 0.7, 200))
                            .clipped()
                            .clipShape(UnevenRoundedRectangle(
                                topLeadingRadius: 12, bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0, topTrailingRadius: 12))
                        Text(cardTitle.isEmpty ? "La Mia Card" : cardTitle)
                            .font(.subheadline.bold()).foregroundStyle(.white)
                            .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "1e2d4a"))
                            .clipShape(UnevenRoundedRectangle(
                                topLeadingRadius: 0, bottomLeadingRadius: 12,
                                bottomTrailingRadius: 12, topTrailingRadius: 0))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.4), radius: 16)
                    .padding(24)
                }
            }
            .frame(height: 260)
        }
    }

    var saveButton: some View {
        Button { saveCard() } label: {
            HStack(spacing: 10) {
                if isProcessing {
                    ProgressView().tint(.white)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Salva Card")
                }
            }
            .font(.headline).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(
                        colors: [Color(hex: "e94560"), Color(hex: "c42b47")],
                        startPoint: .leading, endPoint: .trailing))
            )
        }
        .disabled(isProcessing).padding(.bottom, 20)
    }

    // MARK: - Helpers

    func loadImage() {
        guard let item = selectedPhotoItem else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let ui = UIImage(data: data) {
                await MainActor.run { selectedImage = ui }
            }
        }
    }

    func saveCard() {
        guard let img = selectedImage,
              let data = img.jpegData(compressionQuality: 0.8) else { return }
        isProcessing = true

        // Snapshot coordinate at save time
        let coordinate = locationManager.currentCoordinate

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let card = PhotoCard(
                title: cardTitle,
                imageData: data,
                cardSize: selectedSize,
                coordinate: coordinate        // nil-safe — model handles optional
            )
            modelContext.insert(card)
            isProcessing = false

            // Reset form
            selectedImage     = nil
            selectedPhotoItem = nil
            cardTitle         = ""
            selectedSize      = .medium

            withAnimation { showSavedBanner = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { showSavedBanner = false }
            }
        }
    }
}

// MARK: - SizeOptionButton

struct SizeOptionButton: View {
    let size: CardSize
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: size.icon).font(.system(size: 18))
                Text(size.rawValue).font(.system(size: 9, weight: .semibold)).tracking(0.5)
            }
            .foregroundStyle(isSelected ? .white : .white.opacity(0.4))
            .frame(maxWidth: .infinity).padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color(hex: "e94560") : Color(hex: "1e2d4a"))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? .clear : .white.opacity(0.1), lineWidth: 1))
            )
        }
    }
}
