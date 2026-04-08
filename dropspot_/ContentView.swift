//
//  ContentView.swift
//  baby
//
//  Created by Navyashree Byregowda on 01/04/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PhotoCard.createdAt, order: .reverse) private var cards: [PhotoCard]

    @State private var showAddCard     = false
    @State private var selectedCard: PhotoCard?
    @State private var showDeleteAlert = false
    @State private var cardToDelete: PhotoCard?
    @State private var showARGallery   = false   // ← NUOVO

    private let columns = [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if cards.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(cards) { card in
                                CardThumbnailView(card: card)
                                    .onTapGesture { selectedCard = card }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            cardToDelete    = card
                                            showDeleteAlert = true
                                        } label: {
                                            Label("Elimina", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Le Mie Foto Card")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                // Bottone AR Gallery — sinistra
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showARGallery = true } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "arkit")
                                .font(.title2)
                            Text("AR")
                                .font(.caption.bold())
                        }
                        .foregroundStyle(.white)
                    }
                }
                // Bottone aggiungi — destra
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAddCard = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
            }
            .sheet(isPresented: $showAddCard) { AddCardView() }
            .fullScreenCover(item: $selectedCard) { card in CardDetailView(card: card) }
            .fullScreenCover(isPresented: $showARGallery) { ARGalleryView() }  // ← NUOVO
            .alert("Elimina Card", isPresented: $showDeleteAlert) {
                Button("Elimina", role: .destructive) {
                    if let card = cardToDelete { modelContext.delete(card) }
                }
                Button("Annulla", role: .cancel) {}
            } message: {
                Text("Sei sicuro di voler eliminare questa card?")
            }
        }
    }

    var emptyStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle().fill(.white.opacity(0.05)).frame(width: 120, height: 120)
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 48))
                    .foregroundStyle(.white.opacity(0.4))
            }
            VStack(spacing: 8) {
                Text("Nessuna Card")
                    .font(.title2.bold()).foregroundStyle(.white)
                Text("Tocca + per aggiungere la tua prima foto card")
                    .font(.subheadline).foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            Button { showAddCard = true } label: {
                Label("Aggiungi Card", systemImage: "plus")
                    .font(.headline).foregroundStyle(.white)
                    .padding(.horizontal, 24).padding(.vertical, 14)
                    .background(Capsule().fill(Color(hex: "e94560")))
            }
        }
        .padding(40)
    }
}

// MARK: - CardThumbnailView

struct CardThumbnailView: View {
    let card: PhotoCard

    var body: some View {
        VStack(spacing: 0) {
            if let image = card.image {
                Image(uiImage: image)
                    .resizable().scaledToFill()
                    .frame(height: 160).clipped()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(card.title.isEmpty ? "Card" : card.title)
                    .font(.caption.bold()).foregroundStyle(.white).lineLimit(1)
                HStack(spacing: 4) {
                    Image(systemName: card.size.icon).font(.system(size: 9))
                    Text(card.size.rawValue).font(.system(size: 10))
                }
                .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, 10).padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "1e2d4a"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.1), lineWidth: 1))
        .shadow(color: .black.opacity(0.4), radius: 8, y: 4)
    }
}
