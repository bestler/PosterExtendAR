//
//  MediumModel.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 07.04.23.
//

import Foundation
import RealityKit
import AVFoundation
import SwiftUI

protocol ARMedium {

    var id: UUID { get set }
    var position: ContentPosition { get set }
    var isPortraitMode: Bool {get set}
    var previewImage: UIImage? {get set}
    var width: Float { get set }
    var height: Float { get set }

    func createModelEntity() -> ModelEntity
}

enum MediumType {
    case video, image
}

enum ContentPosition: String, CaseIterable {
    case top = "top", bottom = "bottom", left = "left", right = "right"
}
