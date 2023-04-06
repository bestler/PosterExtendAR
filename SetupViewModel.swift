//
//  SetupViewModel.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 06.04.23.
//

import Foundation
import SwiftUI

class SetupViewModel: ObservableObject {

    @Published var anchorImage: Image?
    @Published var inputAnchorImage: UIImage?

    let arExperience = ARViewContainer()


    func loadImage() {
        guard let inputAnchorImage = inputAnchorImage else {return}
        anchorImage = Image(uiImage: inputAnchorImage)

        //TODO: Make sure that it happens ansynchronously in the background
        arExperience.setRefImage(inputAnchorImage)
    }

}
