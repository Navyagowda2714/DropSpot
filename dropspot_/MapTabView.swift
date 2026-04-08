//
//  MapTabView.swift
//  baby
//
 
import SwiftUI
import MapKit
import SwiftData
import CoreLocation
 
// Helper to derive coordinate from stored lat/long on PhotoCard
private extension PhotoCard {
    var mapCoordinate: CLLocationCoordinate2D? {
        // Try common model shapes for coordinates
        // 1) If you store a CLLocationCoordinate2D directly
        if let coord = (self as AnyObject).value(forKey: "coordinate") as? CLLocationCoordinate2D {
            return coord
        }
        // 2) If you store a CLLocation
        if let location = (self as AnyObject).value(forKey: "location") as? CLLocation {
            return location.coordinate
        }
        // 3) If you store optional Doubles under different names
        if let lat = (self as AnyObject).value(forKey: "lat") as? Double,
           let lon = (self as AnyObject).value(forKey: "lon") as? Double {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        if let lat = (self as AnyObject).value(forKey: "latitude") as? Double,
           let lon = (self as AnyObject).value(forKey: "longitude") as? Double {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        // No coordinate available
        return nil
    }
}
 
// MARK: - Map Tab (replaces MapPlaceholderView)
 
struct MapTabView: View {
    @StateObject private var locationManager = LocationManager()
    @Query(sort: \PhotoCard.createdAt, order: .reverse) private var cards: [PhotoCard]
 
    var body: some View {
        ZStack {
            Map(position: $locationManager.position) {
                // User location dot
                UserAnnotation(anchor: .center) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "e94560").opacity(0.25))
                            .frame(width: 36, height: 36)
                        Circle()
                            .fill(Color(hex: "e94560"))
                            .frame(width: 14, height: 14)
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .frame(width: 14, height: 14)
                    }
                }
 
                
                ForEach(cards.filter { $0.mapCoordinate != nil }) { card in
                    Annotation("", coordinate: card.mapCoordinate!) {
                        CardMapPin(card: card)
                    }
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .ignoresSafeArea()
 
            // Re-center button
            VStack {
                Spacer()
                HStack {
                    Button {
                        locationManager.requestLocation()
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundStyle(Color(hex: "e94560"))
                            .padding(14)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 6)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
 
            // Empty hint when no cards have a location yet
            if cards.filter({ $0.mapCoordinate != nil }).isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        Text("Cattura una foto per appuntarla sulla mappa")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.3), radius: 6)
                            .padding(.top, 60)
                            .padding(.trailing, 16)
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}
 
// MARK: - Pin card shown on the map
 
struct CardMapPin: View {
    let card: PhotoCard
    @State private var expanded = false
 
    var body: some View {
        VStack(spacing: 4) {
            if expanded {
                // Expanded: show image + title
                VStack(spacing: 0) {
                    if let image = card.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .clipped()
                            .clipShape(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 10,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 10
                                )
                            )
                    }
 
                    Text(card.title.isEmpty ? "Card" : card.title)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .frame(width: 90, alignment: .leading)
                        .background(Color(hex: "1e2d4a"))
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 10,
                                bottomTrailingRadius: 10,
                                topTrailingRadius: 0
                            )
                        )
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.45), radius: 8, y: 3)
                .transition(.scale(scale: 0.7).combined(with: .opacity))
            }
 
            // Always-visible pin icon
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundStyle(Color(hex: "e94560"))
                .shadow(color: .black.opacity(0.4), radius: 4)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                expanded.toggle()
            }
        }
    }
}

