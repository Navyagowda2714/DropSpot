//
//  babyApp.swift
//  baby
//
//  Created by Gennaro Biagino on 01/04/2026.
//

import SwiftUI
import SwiftData

@main
struct babyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: PhotoCard.self)
        }
    }
}
