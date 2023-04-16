//
//  VideoPicker.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 07.04.23.
//

import Foundation
import SwiftUI
import PhotosUI

//Why is PhotosPicker not supported in Swift Playground Apps??

struct VideoPicker: UIViewControllerRepresentable {

    @Binding var showingPicker: Bool
    @Binding var url: URL?
    @Binding var progress: Progress?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.showingPicker = false
            guard let provider = results.first?.itemProvider else {return}
            parent.progress = provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier, completionHandler: { url, _ in
                guard let url = url else {return}
                let fileName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                let newURL = FileManager.default.temporaryDirectory.appending(path: fileName)
                try! FileManager.default.copyItem(at: url, to: newURL)
                self.updatevideoURL(newURL.absoluteURL)
            })
        }

        private func updatevideoURL(_ url: URL?){
            DispatchQueue.main.async {
                self.parent.url = url
            }
        }
    }
}
