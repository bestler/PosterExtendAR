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

    @Published var showingARExperience: Bool = false {
        didSet {
            //Reset experience if you close the ARView
            if showingARExperience == false {
                arExperience.arView.session.pause()
                self.arExperience = ARViewContainer()
                if let anchorImage{
                    self.arExperience.setRefImage(anchorImage)
                }
                self.arExperience.media = self.media

            }
        }
    }
    @Published var anchorImage: UIImage? {
        didSet {
            guard let anchorImage else {return}
            arExperience.setRefImage(anchorImage)
        }
    }

    @Published var media : [ContentPosition:ARMedium?] = [ContentPosition:ARMedium?](){
        didSet{
            arExperience.media = media
        }
    }
    var arExperience = ARViewContainer()

}
