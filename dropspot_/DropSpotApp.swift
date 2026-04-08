//
//  DropSpotApp.swift
//  baby
//
//  Created by Navyashree Byregowda on 01/04/2026.
//

import SwiftUI
import SwiftData

@main
struct DropSpotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: PhotoCard.self)
        }
    }
}
