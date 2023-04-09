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

protocol Medium {

    var position: ContentPosition { get set }
    var isPortraitMode: Bool {get set}
    var previewImage: UIImage? {get set}
    var width: Float { get set }
    var height: Float { get set }

    func createModelEntity() -> ModelEntity
}

enum MediumType {
    case video, image, text
}

enum ContentPosition: String, CaseIterable {
    case top = "top", bottom = "bottom", left = "left", right = "right"
}
