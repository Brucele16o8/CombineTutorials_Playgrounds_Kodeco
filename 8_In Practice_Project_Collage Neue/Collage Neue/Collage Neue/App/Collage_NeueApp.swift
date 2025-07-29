//
//  Collage_NeueApp.swift
//  Collage Neue
//
//  Created by Tung Le on 28/7/2025.
//

import SwiftUI

@main
struct Collage_NeueApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(CollageNeueModel())
        }
    }
}
