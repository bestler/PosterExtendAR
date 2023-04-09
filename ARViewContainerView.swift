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
    var media : [ContentPosition:ARVideoMedium?] = [ContentPosition:ARVideoMedium?]()
    var currentAnchor : AnchorEntity?

    func makeUIView(context: Context) -> ARView {

        arView.session.delegate = context.coordinator
        //Create AR configuration
        configuration.maximumNumberOfTrackedImages = 1
        arView.session.run(configuration)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }

    func stopPlayback(){
        if let anchor = arView.scene.anchors.first {
            for position in ContentPosition.allCases {
                let entityTop = anchor.findEntity(named: position.rawValue)
                if let modelEntity = (entityTop as? ModelEntity) {
                    if let material = (modelEntity.model?.materials.first as? VideoMaterial){
                        material.avPlayer?.pause()
                    }
                }
            }
        }
    }

    func setRefImage(_ image : UIImage) {
        print(image.imageOrientation.rawValue)
        if let cgImage = image.cgImage {
            let refImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation(image.imageOrientation), physicalWidth: 0.4)
            configuration.detectionImages = [refImage]
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator : NSObject, ARSessionDelegate {

        var parent: ARViewContainer

        init(_ parent :ARViewContainer) {
            self.parent = parent
        }


        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let myAnchor = anchor as? ARImageAnchor {
                    var imageAnchor = AnchorEntity(.anchor(identifier: myAnchor.identifier))
                    parent.currentAnchor = imageAnchor
                    let anchorWidth = Float(myAnchor.referenceImage.physicalSize.width)
                    let anchorHeight = Float(myAnchor.referenceImage.physicalSize.height)
                    imageAnchor = attachMedia(imageAnchor: imageAnchor, anchorWidth: anchorWidth, anchorHeigt: anchorHeight)
                    parent.arView.scene.addAnchor(imageAnchor)
                    print("Added anchor")
                }
            }
        }

        func attachMedia(imageAnchor: AnchorEntity, anchorWidth: Float, anchorHeigt: Float) -> AnchorEntity {
            for (position, medium) in parent.media {
                if let medium {
                    let entity = medium.createModelEntity()
                    var offsetForAlignment: Float = 0.0
                    switch position {
                    case .top:
                        offsetForAlignment = anchorHeigt/2 + medium.height/2 + 0.02 //2cm padding
                        entity.setPosition(simd_float3(0,0, -offsetForAlignment), relativeTo: imageAnchor)
                    case .bottom:
                        offsetForAlignment = anchorHeigt/2 + medium.height/2 + 0.02
                        entity.setPosition(simd_float3(0,0, offsetForAlignment), relativeTo: imageAnchor)
                    case .left:
                        offsetForAlignment = anchorWidth/2 + medium.width/2 + 0.02
                        entity.setPosition(simd_float3(-offsetForAlignment,0,0), relativeTo: imageAnchor)
                    case .right:
                        offsetForAlignment = anchorWidth/2 + medium.width/2 + 0.02
                        entity.setPosition(simd_float3(offsetForAlignment,0,0), relativeTo: imageAnchor)
                    }
                    entity.name = position.rawValue
                    if medium.isPortraitMode {
                        entity.transform.rotation = simd_quatf(angle: GLKMathDegreesToRadians(-90), axis: SIMD3(x: 0, y: 1, z: 0))
                    }
                    entity.setParent(imageAnchor)
                }
            }
            return imageAnchor
        }
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
        @unknown default:
                self = .up
        }
    }
}
