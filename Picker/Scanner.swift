//
//  File.swift
//  
//
//  Created by Simon Bestler on 17.04.23.
//

import Foundation
import SwiftUI
import UIKit
import VisionKit


struct Scanner: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var showingScanner: Bool

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {

        let parent: Scanner

        init(_ parent: Scanner) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            parent.showingScanner = false
            guard scan.pageCount > 0 else {return}
            //Select last image
            parent.image = scan.imageOfPage(at: scan.pageCount-1)
        }

    }
}
