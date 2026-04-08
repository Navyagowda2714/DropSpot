//
//  modelsphotocard.swift
//  baby
//
//  Created by Navyashree Byregowda on 01/04/2026.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

enum CardSize: String, Codable, CaseIterable {
    case small      = "Small"
    case medium     = "Medium"
    case large      = "Large"
    case fullscreen = "Full Screen"

    var dimensions: CGSize {
        switch self {
        case .small:      return CGSize(width: 160, height: 200)
        case .medium:     return CGSize(width: 260, height: 320)
        case .large:      return CGSize(width: 340, height: 420)
        case .fullscreen: return CGSize(
            width:  UIScreen.main.bounds.width - 40,
            height: UIScreen.main.bounds.height * 0.75)
        }
    }

    var icon: String {
        switch self {
        case .small:      return "rectangle.portrait"
        case .medium:     return "rectangle.portrait.fill"
        case .large:      return "photo"
        case .fullscreen: return "arrow.up.left.and.arrow.down.right"
        }
    }
}

@Model
class PhotoCard {
    var id: UUID
    var title: String
    var imageData: Data
    var cardSize: String
    var createdAt: Date
    var colorTint: String

    init(title: String, imageData: Data, cardSize: CardSize, colorTint: String = "#FFFFFF") {
        self.id        = UUID()
        self.title     = title
        self.imageData = imageData
        self.cardSize  = cardSize.rawValue
        self.createdAt = Date()
        self.colorTint = colorTint
    }

    var size: CardSize  { CardSize(rawValue: cardSize) ?? .medium }
    var image: UIImage? { UIImage(data: imageData) }
}
