
import SwiftUI

struct CombinedAuroraView: View {
    @Binding var intensity: Float
    @State private var rotationAngle: Double = 0.0
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack {
            VerticalAurorasView(intensity: $intensity, rotationAngle: $rotationAngle)
            HorizontalAurorasView(intensity: $intensity, rotationAngle: $rotationAngle)
        }
        .frame(width: 1000, height: 1000) // Set a fixed frame size for the auroras
        .offset(y: -300) // Raise the view high up to simulate "in the sky"
        .rotation3DEffect(.degrees(-30), axis: (x: 1, y: 0, z: 0)) // Tilt it upward to appear more in the sky
        .onAppear {
            startRotationTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func startRotationTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(Animation.linear(duration: 0.1)) {
                rotationAngle += 0.05 // Adjust rotation speed
                if rotationAngle >= 360 {
                    rotationAngle = 0 // Reset after full rotation
                }
            }
        }
    }
}


struct CombinedAuroraView_Previews: PreviewProvider {
    @State static var intensity: Float = 50.0

    static var previews: some View {
        CombinedAuroraView(intensity: $intensity)
    }
}
