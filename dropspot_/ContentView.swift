//
//  ContentView.swift
//  baby
//
//  Created by Gennaro Biagino on 01/04/2026.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation
import RealityKit

//
//  ContentView.swift
//  baby
//
//  Created by Gennaro Biagino on 01/04/2026.
//
 
import SwiftUI
import SwiftData
 
struct ContentView: View {
    var body: some View {
        TabView {
            // Tab 1 — Map with pinned PhotoCards
            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
 
            // Tab 2 — Capture / Camera
            AddCardView()
                .tabItem {
                    Label("Capture", systemImage: "camera.fill")
                }
 
            // Tab 3 — My Photos
            PhotosTabView()
                .tabItem {
                    Label("Profile", systemImage: "photo.on.rectangle.angled")
                }
        }
        .tint(Color(hex: "e94560"))
    }
}
 
// MARK: - Photos Tab
 
struct PhotosTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PhotoCard.createdAt, order: .reverse) private var cards: [PhotoCard]
 
    @State private var selectedCard: PhotoCard?
    @State private var showDeleteAlert = false
    @State private var cardToDelete: PhotoCard?
    @State private var showARGallery   = false
 
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
                ToolbarItem(placement: .navigationBarTrailing) {
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
            }
            .fullScreenCover(item: $selectedCard) { card in CardDetailView(card: card) }
            .fullScreenCover(isPresented: $showARGallery) { ARGalleryView() }
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
                Text("Vai su Cattura per aggiungere la tua prima foto card")
                    .font(.subheadline).foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
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
                    // Show pin badge if card has a saved location
                    if card.coordinate != nil {
                        Spacer()
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(Color(hex: "e94560"))
                    }
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
