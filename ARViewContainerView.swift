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


    func makeUIView(context: Context) -> ARView {

        arView.session.delegate = context.coordinator

        // Create reference
        let myImage = UIImage(named: "NCX-Poster")!
        let refImage = ARReferenceImage(myImage.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.5)


        //Create AR configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = [refImage]
        configuration.maximumNumberOfTrackedImages = 1

        arView.session.run(configuration)


        return arView
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
                        let imageAnchor = AnchorEntity(anchor: myAnchor)
                        let entity = ModelEntity(mesh: .generateBox(size: 0.1))
                        entity.setParent(imageAnchor)
                       //imageAnchor.addChild(entity)
                        parent.scene.addAnchor(imageAnchor)
                       print("Added anchor")
                   }
            }
        }

    }


}
