//
//  SetupViewModel.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 06.04.23.
//

import Foundation
import SwiftUI

@MainActor
class SetupViewModel: ObservableObject {

    @Published var anchorImage: Image?
    @Published var inputAnchorImage: UIImage?
    @Published var videoURL: URL? {
        didSet {
            arExperience.videoURL = videoURL
        }
    }

    var arExperience = ARViewContainer()


    func loadImage(_ image : UIImage?) {
        guard let image = image else {return}
        anchorImage = Image(uiImage: image)
        self.arExperience.setRefImage(image)
    }

}
