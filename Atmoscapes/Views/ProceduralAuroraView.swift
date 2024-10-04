import SwiftUI
import RealityKit

struct ProceduralAuroraView: View {
    @Binding var intensity: Float
    @State private var originalVertices: [SIMD3<Float>] = [] // Store the original vertices

    var body: some View {
        ZStack {
            RealityKitProceduralAuroraView(intensity: intensity, originalVertices: $originalVertices)
                .edgesIgnoringSafeArea(.all)

            Text("Procedural Aurora Effect")
                .foregroundColor(.white)
                .font(.title2)
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(8)
                .padding()
        }
        .onAppear {
            setupOriginalVertices()
        }
    }

    // Set up the original vertices with bigger shapes
    func setupOriginalVertices() {
        let segments = 25 // Fewer segments for larger shapes
        var vertices: [SIMD3<Float>] = []

        let width: Float = 40.0 // Increase width for larger aurora shapes
        let height: Float = 10.0

        // Generate vertices for a large grid
        for x in 0..<segments {
            let fx = Float(x) / Float(segments - 1)
            for y in 0..<segments {
                let fy = Float(y) / Float(segments - 1)
                let randomOffset: Float = Float.random(in: -1.0...1.0) // Randomness for organic effect
                vertices.append([fx * width - width / 2, randomOffset, fy * height - height / 2])
            }
        }

        originalVertices = vertices // Store the original vertices for animation
    }
}

struct RealityKitProceduralAuroraView: View {
    var intensity: Float
    @Binding var originalVertices: [SIMD3<Float>]

    var body: some View {
        RealityView { content in
            guard !originalVertices.isEmpty else {
                print("Vertices not generated")
                return
            }

            let auroraEntity = createProceduralAurora()
            content.add(auroraEntity)
        }
    }

    func createProceduralAurora() -> ModelEntity {
        let segments = 25 // Match the segments in the setup
        var indices: [UInt32] = []

        // Create larger triangles for a bigger mesh
        for x in 0..<segments - 1 {
            for y in 0..<segments - 1 {
                let topLeft = UInt32(y * segments + x)
                let topRight = UInt32(y * segments + x + 1)
                let bottomLeft = UInt32((y + 1) * segments + x)
                let bottomRight = UInt32((y + 1) * segments + x + 1)

                // Add two triangles for each grid cell
                indices.append(topLeft)
                indices.append(bottomLeft)
                indices.append(bottomRight)

                indices.append(topLeft)
                indices.append(bottomRight)
                indices.append(topRight)
            }
        }

        var meshDescriptor = MeshDescriptor(name: "AuroraWave")
        meshDescriptor.positions = MeshBuffers.Positions(originalVertices)
        meshDescriptor.primitives = MeshDescriptor.Primitives.triangles(indices)

        let mesh = try! MeshResource.generate(from: [meshDescriptor])

        // Adjusting color with gradients and opacity based on intensity
        let hue = Double(intensity / 100) * 0.5 // Adjust hue for a gradient effect
        let material = SimpleMaterial(color: UIColor(hue: CGFloat(hue), saturation: 0.6, brightness: 0.8, alpha: CGFloat(intensity / 100)), isMetallic: false)

        let auroraEntity = ModelEntity(mesh: mesh, materials: [material])
        print("Aurora Entity Generated")
        animateAuroraWave(auroraEntity)
        return auroraEntity
    }

    // Animation for the wave motion
    func animateAuroraWave(_ entity: ModelEntity) {
        let startTime = Date() // Capture the start time when the animation begins

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let currentTime = Date() // Get the current time during the update
            let elapsedTime = Float(currentTime.timeIntervalSince(startTime)) // Calculate elapsed time in seconds

            // Simplify the wave animation variables
            let waveSpeed: Float = 0.5 // Slower wave speed for bigger shapes
            let frequency: Float = 0.05 // Larger frequency for smoother waves
            let amplitude: Float = 1.0 // Higher amplitude for larger motion

            var animatedVertices = originalVertices

            // Apply wave animation by modifying vertices
            for i in 0..<animatedVertices.count {
                let phaseShift = Float(i) * frequency + elapsedTime * waveSpeed
                let waveHeight = sin(phaseShift) * amplitude
                animatedVertices[i].y = waveHeight
            }

            // Regenerate the mesh with the updated vertices
            var meshDescriptor = MeshDescriptor(name: "AnimatedAuroraWave")
            meshDescriptor.positions = MeshBuffers.Positions(animatedVertices)
            meshDescriptor.primitives = MeshDescriptor.Primitives.triangles(Array(0..<UInt32(animatedVertices.count)))

            let newMesh = try! MeshResource.generate(from: [meshDescriptor])
            entity.model?.mesh = newMesh // Replace the mesh with the updated one
        }
    }
}

struct ProceduralAuroraView_Previews: PreviewProvider {
    @State static var intensity: Float = 50.0

    static var previews: some View {
        ProceduralAuroraView(intensity: $intensity)
    }
}
