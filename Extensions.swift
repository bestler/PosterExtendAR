//
//  Extensions.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 14.04.23.
//

import Foundation
import SwiftUI

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
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


extension FileManager {
    func clearTempDirectory() {
        do {
            let tempURL = self.temporaryDirectory
            let temDirectory = try contentsOfDirectory(atPath: tempURL.path())
            temDirectory.forEach({ file in
                let fileURL = tempURL.appending(path: file, directoryHint: .notDirectory)
                try! removeItem(atPath: fileURL.path())
            })
        } catch {
            print(error)
        }
    }
}
