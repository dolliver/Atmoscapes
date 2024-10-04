import SwiftUI

struct EffectSelectionView: View {
    @Binding var intensity: Float
    @State private var isAuroraOn: Bool = false // Track if Aurora is on or off
    @State private var panelOffset = CGSize.zero // For moving the panel

    var body: some View {
        ZStack {
            // Combined Aurora View (Shown/Hidden based on toggle)
            if isAuroraOn {
                CombinedAuroraView(intensity: $intensity)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false) // Prevent user interaction with aurora
            }

            // Control Panel with button and slider
            VStack(spacing: 20) {
                Text("Select an Atmosphere Effect")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                // Aurora Toggle Button
                Button(action: {
                    isAuroraOn.toggle() // Toggle Aurora On/Off
                }) {
                    Text("Aurora")
                        .font(.title2)
                        .frame(width: 150, height: 50)
                        .background(isAuroraOn ? Color.green : Color.gray) // Background color for On/Off
                        .foregroundColor(isAuroraOn ? Color.white : Color.black) // Font color for On/Off
                        .cornerRadius(8)
                        .padding()
                }

                // Intensity Slider (smaller size)
                Slider(value: $intensity, in: 0...100)
                    .frame(width: 200) // Adjust slider width
                    .padding()

                Text("Intensity: \(Int(intensity))") // Show intensity value
                    .foregroundColor(.white)
            }
            .padding()
            .frame(width: 250, height: 250) // Set the size for the control panel
            .background(Color.gray.opacity(0.5)) // Background with opacity for panel
            .cornerRadius(12)
            .shadow(radius: 10)
            .offset(panelOffset) // Allow moving the panel
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        panelOffset = gesture.translation
                    }
                    .onEnded { _ in
                        panelOffset = panelOffset
                    }
            )
            .overlay( // Optional: add a visual indicator for the drag bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 100, height: 4)
                    .padding(.top, 8),
                alignment: .bottom // Keep the bar close to the panel
            )
        }
    }
}

// Preview for testing
struct EffectSelectionView_Previews: PreviewProvider {
    @State static var intensity: Float = 50.0

    static var previews: some View {
        EffectSelectionView(intensity: $intensity)
    }
}
