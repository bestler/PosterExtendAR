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
    var videoURL : URL?

    func makeUIView(context: Context) -> ARView {

        arView.session.delegate = context.coordinator

        //Create AR configuration
        configuration.maximumNumberOfTrackedImages = 1

        arView.session.run(configuration)
        return arView
    }

    func setRefImage(_ image : UIImage) {
        print(image.imageOrientation.rawValue)
        if let cgImage = image.cgImage {
            let refImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation(image.imageOrientation), physicalWidth: 0.4)
            configuration.detectionImages = [refImage]
        }
    }

    func updateUIView(_ uiView: ARView, context: Context) {

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
                    let imageAnchor = AnchorEntity(.anchor(identifier: myAnchor.identifier))
                    //let entity = ModelEntity(mesh: .generateBox(size: 0.1))
                    let entity = ARUtils.createVideoEntity(videoURL: parent.videoURL)
                    entity.setPosition(simd_float3(0, 0, -0.4), relativeTo: imageAnchor)
                    entity.setParent(imageAnchor)
                    parent.arView.scene.addAnchor(imageAnchor)
                    print("Added anchor")
                }
            }
        }
    }
}

class ARUtils {
    static func createVideoEntity(videoURL : URL?) -> ModelEntity {
        let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.5, 0.02, 0.5)))
        if let videoURL {
            let asset = AVURLAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            let videoMaterial = VideoMaterial(avPlayer: player)
            box.model?.materials = [videoMaterial]
            player.play()
        }
        return box
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
