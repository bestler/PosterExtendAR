//
//  File.swift
//  
//
//  Created by Simon Bestler on 09.04.23.
//

import Foundation
import SwiftUI
import RealityKit

struct ARImageMedium: ARMedium {

    var position: ContentPosition

    var isPortraitMode: Bool = false

    var previewImage: UIImage?

    var width: Float = 0.8

    var height: Float = 0.45

    func createModelEntity() -> ModelEntity {

        var box = ModelEntity()
        if isPortraitMode {
            box = ModelEntity(mesh: .generateBox(size: simd_make_float3(height, 0.01, width), cornerRadius: 0.3))
        } else {
            box = ModelEntity(mesh: .generateBox(size: simd_make_float3(width, 0.01, height), cornerRadius: 0.3))
        }

        let tempFileUrl = FileManager.default.temporaryDirectory.appendingPathComponent("img-\(UUID().uuidString).jpeg")

        if let previewImage {
            let jpegData = previewImage.jpegData(compressionQuality: 0.9)
            if let jpegData {
                do {
                    try jpegData.write(to: tempFileUrl)
                    let texture = try TextureResource.load(contentsOf: tempFileUrl)
                    let materialTexture = MaterialParameters.Texture(texture)
                    var imageMaterial = UnlitMaterial()
                    imageMaterial.color = PhysicallyBasedMaterial.BaseColor(texture: materialTexture)
                    box.model?.materials = [imageMaterial]
                } catch {
                    print(error)
                }
            }
        }
        return box
    }

}
