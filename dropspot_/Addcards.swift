//  Addcards.swift

//
//  Created by Navyashree Byregowda on 01/04/2026.
//

import SwiftUI
import PhotosUI
import SwiftData
import Combine

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var cardTitle     = ""
    @State private var selectedSize: CardSize = .medium
    @State private var showCamera    = false
    @State private var isProcessing  = false

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
                            saveButton
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Nuova Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") { dismiss() }
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .sheet(isPresented: $showCamera) { CameraView(image: $selectedImage) }
        }
    }

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

    func loadImage() {
        guard let item = selectedPhotoItem else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let ui = UIImage( data: data) {
                await MainActor.run { selectedImage = ui }
            }
        }
    }

    func saveCard() {
        guard let img = selectedImage,
              let data = img.jpegData(compressionQuality: 0.8) else { return }
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let card = PhotoCard(title: cardTitle, imageData: data, cardSize: selectedSize)
            modelContext.insert(card)
            isProcessing = false
            dismiss()
        }
    }
}

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
