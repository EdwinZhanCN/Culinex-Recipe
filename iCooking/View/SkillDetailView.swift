//
//  SkillDetailView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/3/24.
//

import SwiftUI
import RealityKit
import ARKit

struct SkillARView: View {
    let skill: Skill
    @State private var arViewContainer = ARViewContainer()
    @State private var isARMode = true // Toggle between AR and preview modes
    @State private var arObjectEntity: Entity?
    @State private var showLoadingError = false
    @State private var isSessionPaused = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            // Toggle between AR and Preview modes
            Picker("Mode", selection: $isARMode) {
                Text("AR Mode").tag(true)
                Text("Preview Mode").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // ARView Container
            arViewContainer
                .onAppear {
                    loadARObject()
                }
                .onChange(of: isARMode) { oldValue, newValue in
                    configureARView()
                }
                .alert(isPresented: $showLoadingError) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Failed to load AR content."),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
        .navigationTitle(skill.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button("Cancel") {
                dismiss()
            },
            trailing: HStack {
                Button(action: {
                    isSessionPaused.toggle()
                    if isSessionPaused {
                        arViewContainer.pauseSession()
                    } else {
                        arViewContainer.resumeSession()
                    }
                }) {
                    Text(isSessionPaused ? "Resume" : "Pause")
                }
                Button("Done") {
                    dismiss()
                }
            }
        )
    }

    private func loadARObject() {
        guard let arData = skill.ARObject else {
            showLoadingError = true
            return
        }

        do {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempRealityFile.reality")
            try arData.write(to: tempURL)

            // Load the Entity from the temporary file
            let entity = try Entity.load(contentsOf: tempURL)
            arObjectEntity = entity

            // Remove the temporary file
            try FileManager.default.removeItem(at: tempURL)

            configureARView()
        } catch {
            print("Error loading AR content: \(error)")
            showLoadingError = true
        }
    }

    private func configureARView() {
        arViewContainer.setupARView(isARMode: isARMode, arObjectEntity: arObjectEntity)
    }
}

struct ARViewContainer: UIViewRepresentable {
    let arView = ARView(frame: .zero)

    func makeUIView(context: Context) -> ARView {
        arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Updates are handled via setupARView
    }

    func setupARView(isARMode: Bool, arObjectEntity: Entity?) {
        // Clear existing scene
        arView.scene.anchors.removeAll()

        if isARMode {
            // Configure for AR mode
            let config = ARWorldTrackingConfiguration()
            config.planeDetection = [.horizontal, .vertical]
            arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])

            // Add coaching overlay if not already added
            if arView.subviews.first(where: { $0 is ARCoachingOverlayView }) == nil {
                let coachingOverlay = ARCoachingOverlayView()
                coachingOverlay.session = arView.session
                coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                coachingOverlay.goal = .anyPlane
                arView.addSubview(coachingOverlay)
            }

            // Place the entity in the scene
            if let entity = arObjectEntity {
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(entity)
                arView.scene.addAnchor(anchorEntity)
            }
        } else {
            // Configure for non-AR preview mode
            arView.session.pause()

            // Set ARView to non-AR mode
            arView.cameraMode = .nonAR

            // Create a camera entity
            let cameraEntity = PerspectiveCamera()
            cameraEntity.transform = Transform(translation: [0, 0, 2])

            // Create a directional light
            let light = DirectionalLight()
            light.light.intensity = 1000
            light.light.color = .white
//            light.light.intensity.exponent = 10
            light.transform.rotation = simd_quatf(angle: -.pi / 4, axis: [1, 0, 0])

            // Create an anchor for the camera and light
            let cameraAnchor = AnchorEntity(world: .zero)
            cameraAnchor.addChild(cameraEntity)
            cameraAnchor.addChild(light)

            // Add the camera anchor to the scene
            arView.scene.addAnchor(cameraAnchor)

            // Place the entity in the scene
            if let entity = arObjectEntity {
                let modelAnchor = AnchorEntity(world: .zero)
                modelAnchor.addChild(entity)
                arView.scene.addAnchor(modelAnchor)
            }
        }
    }

    func pauseSession() {
        arView.session.pause()
    }

    func resumeSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config, options: [])
    }
}
