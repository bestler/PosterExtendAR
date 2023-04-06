//
//  ARViewContainerView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 03.04.23.
//

import SwiftUI
import RealityKit
import ARKit
import Foundation

struct ARViewContainer: UIViewRepresentable {

    var arView = ARView(frame: .zero)
    var configuration = ARWorldTrackingConfiguration()

    func makeUIView(context: Context) -> ARView {

        arView.session.delegate = context.coordinator

        //Create AR configuration
        configuration.maximumNumberOfTrackedImages = 1

        arView.session.run(configuration)
        return arView
    }

    func setRefImage(_ image : UIImage) {
        if let cgImage = image.cgImage {
            let refImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.5)
            configuration.detectionImages = [refImage]
        }
    }

    func updateUIView(_ uiView: ARView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self.arView)
    }

    class Coordinator : NSObject, ARSessionDelegate {

        var parent: ARView

        init(_ parent :ARView) {
            self.parent = parent
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let myAnchor = anchor as? ARImageAnchor {
                    let imageAnchor = AnchorEntity(.anchor(identifier: myAnchor.identifier))
                    let entity = ModelEntity(mesh: .generateBox(size: 0.1))
                    entity.setParent(imageAnchor)
                    parent.scene.addAnchor(imageAnchor)
                    print("Added anchor")
                }
            }
        }
    }
}
