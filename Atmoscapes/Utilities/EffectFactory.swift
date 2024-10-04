//
//  EffectFactory.swift
//  Atmoscapes
//
//  Created by Douglas Oliveira on 04/10/2024.
//

import SwiftUI

enum EffectType {
    case aurora
    case thunderstorm
    case fog
}

class EffectFactory {
    static func createEffect(for type: EffectType, intensity: Double) -> some View {
        // Convert Double to Float and wrap it in a Binding using .constant for now
        let intensityBinding = Binding<Float>(.constant(Float(intensity)))
        var auroraView = ProceduralAuroraView(intensity: intensityBinding?.projectedValue ?? .constant(Float(50.0)))
        
        switch type {
        case .aurora:
            return auroraView
        case .thunderstorm:
            return auroraView //replace for other view later
        case .fog:
            return auroraView //replace for other view later
        }
    }
}
