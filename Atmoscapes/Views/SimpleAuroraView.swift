import SwiftUI
import RealityKit

struct SimpleAuroraView: View {
    @Binding var intensity: Float
    @State private var offsetLayer1: CGFloat = -200
    @State private var colorPhase: Double = 0.0

    var body: some View {
        ZStack {
            auroraLayer(colors: currentAuroraColors(phase: colorPhase))
                .opacity(calculateOpacity(from: Double(intensity))) // Explicit cast to Double
                .blur(radius: 30) // Stronger blur
                .mask(auroraMask()) // Apply a mask to blend edges
                .offset(x: offsetLayer1)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                        offsetLayer1 = 200
                    }
                    withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: true)) {
                        colorPhase = 1.0 // Cycle through color phases
                    }
                }

 
        }
        .edgesIgnoringSafeArea(.all)
    }

    // Aurora gradient with dynamically changing colors
    func auroraLayer(colors: [Color]) -> some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .rotationEffect(.degrees(-45))
    }

    // Function to create a fading mask for the edges of the aurora
    func auroraMask() -> some View {
        RadialGradient(
            gradient: Gradient(colors: [Color.white, Color.clear]),
            center: .center,
            startRadius: 100,
            endRadius: 400
        )
    }

    // Function to interpolate between different aurora color sets
    func currentAuroraColors(phase: Double) -> [Color] {
        let startColors = [Color.green, Color.purple]
        let endColors = [Color.blue, Color.cyan]

        return zip(startColors, endColors).compactMap { (start, end) in
            guard let startComponents = start.components, let endComponents = end.components else { return nil }

            let redComponent = startComponents.red + (endComponents.red - startComponents.red) * CGFloat(phase)
            let greenComponent = startComponents.green + (endComponents.green - startComponents.green) * CGFloat(phase)
            let blueComponent = startComponents.blue + (endComponents.blue - startComponents.blue) * CGFloat(phase)
            
            return Color(
                red: Double(redComponent),
                green: Double(greenComponent),
                blue: Double(blueComponent)
            )
        }
    }

    func calculateOpacity(from intensity: Double) -> Double {
        return min(0.4 + (intensity / 200), 0.85)
    }
}

// Add preview for testing
struct SimpleAuroraView_Previews: PreviewProvider {
    @State static var intensity: Float = 50.0

    static var previews: some View {
        SimpleAuroraView(intensity: $intensity)
    }
}
