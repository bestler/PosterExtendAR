//
//  ImagePicker.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 04.04.23.
//

import Foundation
import SwiftUI
import PhotosUI

//Why is PhotosPicker not supported in Swift Playground Apps??

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var progress: Progress?
    @Binding var showingPicker: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.modalPresentationStyle = .overCurrentContext
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            var newImage : UIImage?
            guard let provider = results.first?.itemProvider else {return}
            if provider.canLoadObject(ofClass: UIImage.self){
                parent.progress = provider.loadObject(ofClass: UIImage.self) { image, _ in
                    newImage = image as? UIImage
                    self.updateImage(newImage)
                }
            }
            parent.showingPicker = false
        }
        
        
        private func updateImage(_ newImage: UIImage?){
            DispatchQueue.main.async {
                self.parent.image = newImage
            }
        }
    }
}

