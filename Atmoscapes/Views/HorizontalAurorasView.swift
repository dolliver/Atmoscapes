import SwiftUI

struct HorizontalAurorasView: View {
    @Binding var intensity: Float
    @Binding var rotationAngle: Double

    @State private var offsets: [CGFloat] = Array(repeating: -200.0, count: 5) // Independent offsets for each aurora
    @State private var opacities: [Double] = Array(repeating: 0.5, count: 5)   // Independent opacities for each aurora

    var body: some View {
        ZStack {
            ForEach(0..<5) { index in
                createHorizontalAurora(at: index)
                    .offset(y: offsets[index]) // Apply independent offset (up/down) to each aurora
                    .opacity(opacities[index]) // Apply independent opacity to each aurora
            }
        }
        .onAppear {
            // Animate each aurora independently
            animateAuroras()
        }
    }

    func createHorizontalAurora(at index: Int) -> some View {
        SimpleAuroraView(intensity: $intensity)
            .rotation3DEffect(
                .degrees(rotationAngle),
                axis: (x: 0, y: 1, z: 0) // Rotation around the y-axis (horizontal)
            )
            .transform3DEffect(
                AffineTransform3D(
                    translation: .init(x: CGFloat(index * 100 - 200), y: CGFloat(index * 50), z: 0)
                )
            ) // Moves auroras to different heights
    }

    func animateAuroras() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in 0..<5 {
                withAnimation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    // Divide auroras into two groups: half start at the top, half start at the bottom
                    if i < 3 {
                        // Top side for the first half
                        offsets[i] = CGFloat.random(in: -300 ... -100)
                    } else {
                        // Bottom side for the second half
                        offsets[i] = CGFloat.random(in: 100 ... 300)
                    }

                    // Randomize the opacity changes for each aurora independently
                    opacities[i] = Double.random(in: 0.4...0.85)
                }
            }
        }
    }
}
