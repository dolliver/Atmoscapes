import SwiftUI

struct VerticalAurorasView: View {
    @Binding var intensity: Float
    @Binding var rotationAngle: Double

    @State private var offsets: [CGFloat] = Array(repeating: -200.0, count: 5) // Independent offsets for each aurora
    @State private var opacities: [Double] = Array(repeating: 0.5, count: 5)   // Independent opacities for each aurora

    var body: some View {
        ZStack {
            ForEach(0..<5) { index in
                createVerticalAurora(at: index)
                    .offset(x: offsets[index]) // Apply independent offset to each aurora
                    .opacity(opacities[index]) // Apply independent opacity to each aurora
            }
        }
        .onAppear {
            // Animate each aurora independently
            animateAuroras()
        }
    }

    func createVerticalAurora(at index: Int) -> some View {
        SimpleAuroraView(intensity: $intensity)
            .rotation3DEffect(
                .degrees(rotationAngle),
                axis: (x: 1, y: 0, z: 0) // Rotation around the x-axis (vertical)
            )
            .transform3DEffect(
                AffineTransform3D(
                    translation: .init(x: 0, y: CGFloat(index * 100 - 200), z: CGFloat(index * 50))
                )
            ) // Moves auroras to different depths
    }

    func animateAuroras() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in 0..<5 {
                withAnimation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    // Divide auroras into two groups: half start from left, half from right
                    if i < 3 {
                        // Left side for the first half
                        offsets[i] = CGFloat.random(in: -300 ... -100)
                    } else {
                        // Right side for the second half
                        offsets[i] = CGFloat.random(in: 100 ... 300)
                    }

                    // Randomize the opacity changes for each aurora independently
                    opacities[i] = Double.random(in: 0.4...0.85)
                }
            }
        }
    }
}
