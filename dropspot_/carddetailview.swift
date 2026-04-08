//
//  carddetailview.swift
//  baby
//
//  Created by Navyashree Byregowda on 01/04/2026.
//


import SwiftUI
import SwiftData

struct CardDetailView: View {
    let card: PhotoCard
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var scale: CGFloat     = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize     = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var showUI             = true
    @State private var showDeleteAlert    = false
    @State private var rotation: Double   = 0
    @State private var showAR             = false

    var body: some View {
        ZStack {
            Color(hex: "040816").ignoresSafeArea()
            StarFieldView()

            if let image = card.image {
                GeometryReader { _ in
                    ZStack {
                        VStack(spacing: 0) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width:  card.size.dimensions.width,
                                    height: card.size.dimensions.height * 0.82
                                )
                                .clipped()
                                .clipShape(UnevenRoundedRectangle(
                                    topLeadingRadius: 18,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 18))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(card.title.isEmpty ? "Foto Card" : card.title)
                                    .font(.headline.bold())
                                    .foregroundStyle(.white)
                                    .lineLimit(2)
                                Text(card.createdAt.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.55))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "101827"))
                            .clipShape(UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 18,
                                bottomTrailingRadius: 18,
                                topTrailingRadius: 0))
                        }
                        .frame(
                            width:  card.size.dimensions.width,
                            height: card.size.dimensions.height
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color(hex: "4f8ef7").opacity(0.25), radius: 30, y: 10)
                        .shadow(color: .black.opacity(0.6), radius: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaleEffect(scale)
                    .offset(offset)
                    .rotationEffect(.degrees(rotation))
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { val in
                                    scale = max(0.4, min(4.0, lastScale * val))
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                },
                            DragGesture()
                                .onChanged { val in
                                    offset = CGSize(
                                        width:  lastOffset.width  + val.translation.width,
                                        height: lastOffset.height + val.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showUI.toggle()
                        }
                    }
                    .onLongPressGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.spring(response: 0.5)) {
                            resetPosition()
                        }
                    }
                }
            }

            // MARK: - UI Overlay
            if showUI {
                VStack {
                    // Top bar
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.8))
                                .background(Circle().fill(.black.opacity(0.3)))
                        }
                        Spacer()
                        Text(card.title.isEmpty ? "Card" : card.title)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        Spacer()
                        Button { showDeleteAlert = true } label: {
                            Image(systemName: "trash.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color(hex: "e94560").opacity(0.9))
                                .background(Circle().fill(.black.opacity(0.3)))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    Spacer()

                    // Bottom controls
                    VStack(spacing: 12) {

                        // Rotation slider
                        HStack(spacing: 12) {
                            Image(systemName: "rotate.left")
                                .foregroundStyle(.white.opacity(0.6))
                            Slider(value: $rotation, in: -45...45, step: 1)
                                .tint(Color(hex: "e94560"))
                            Image(systemName: "rotate.right")
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .padding(.horizontal, 24)

                        // Hints + bottone AR
                        HStack(spacing: 0) {
                            hintLabel("Pizzica",       icon: "hand.pinch")
                            Spacer()
                            hintLabel("Trascina",      icon: "hand.draw")
                            Spacer()
                            hintLabel("Tieni = reset", icon: "hand.tap")
                            Spacer()

                            // Bottone AR
                            Button {
                                showAR = true
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: "arkit")
                                        .font(.system(size: 18))
                                    Text("AR")
                                        .font(.system(size: 9, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "e94560"))
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    }
                    .padding(.vertical, 16)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
                .transition(.opacity)
            }
        }
        .alert("Elimina Card", isPresented: $showDeleteAlert) {
            Button("Elimina", role: .destructive) {
                modelContext.delete(card)
                dismiss()
            }
            Button("Annulla", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showAR) {
            ARCardView(card: card)
        }
    }

    // MARK: - Helpers

    func resetPosition() {
        scale      = 1.0
        lastScale  = 1.0
        offset     = .zero
        lastOffset = .zero
        rotation   = 0
    }

    func hintLabel(_ text: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.caption)
            Text(text).font(.system(size: 9, weight: .medium))
        }
        .foregroundStyle(.white.opacity(0.45))
    }
}

// MARK: - StarFieldView

struct StarFieldView: View {
    let stars: [(CGFloat, CGFloat, CGFloat, Double)] = (0..<80).map { _ in
        (CGFloat.random(in: 0...1),
         CGFloat.random(in: 0...1),
         CGFloat.random(in: 1...3),
         Double.random(in: 0.2...0.8))
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(stars.indices, id: \.self) { i in
                Circle()
                    .fill(.white.opacity(stars[i].3))
                    .frame(width: stars[i].2, height: stars[i].2)
                    .position(
                        x: stars[i].0 * geo.size.width,
                        y: stars[i].1 * geo.size.height
                    )
            }
        }
        .ignoresSafeArea()
    }
}

