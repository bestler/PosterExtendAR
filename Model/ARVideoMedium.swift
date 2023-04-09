//
//  File.swift
//  
//
//  Created by Simon Bestler on 09.04.23.
//

import Foundation
import RealityKit
import AVFoundation
import SwiftUI

struct ARVideoMedium: Medium {

    var position: ContentPosition
    var isPortraitMode: Bool = false
    var playBackWithSound: Bool = true
    var autoPlayEnabled: Bool = true
    var width: Float
    var height: Float
    var url: URL?
    var previewImage: UIImage?

    func createModelEntity() -> ModelEntity {
        var box = ModelEntity()
        if isPortraitMode {
            box = ModelEntity(mesh: .generateBox(size: simd_make_float3(height, 0.01, width), cornerRadius: 0.3))
        } else {
            box = ModelEntity(mesh: .generateBox(size: simd_make_float3(width, 0.01, height), cornerRadius: 0.3))
        }
        if let url {
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            let videoMaterial = VideoMaterial(avPlayer: player)
            box.model?.materials = [videoMaterial]
            if !playBackWithSound {
                player.isMuted = true
            }
            if autoPlayEnabled {
                player.play()
            }
        }
        return box
    }
}
