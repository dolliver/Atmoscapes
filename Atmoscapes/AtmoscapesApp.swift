//
//  AtmoscapesApp.swift
//  Atmoscapes
//
//  Created by Douglas Oliveira on 04/10/2024.
//

import SwiftUI

import SwiftUI

@main
struct AtmoscapesApp: App {
    @State private var intensity: Float = 50.0 // Define the state variable for intensity

    var body: some Scene {
        WindowGroup {
            EffectSelectionView(intensity: $intensity) // Pass the binding for intensity
        }
    }
}
