//
//  File.swift
//  
//
//  Created by Simon Bestler on 17.04.23.
//

import Foundation
import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {

    @Binding var canvasView: PKCanvasView
    @State var toolPicker = PKToolPicker()

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        #if targetEnvironment(simulator)
        canvasView.drawingPolicy = .anyInput
        #endif
        showToolPicker()
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        showToolPicker()
    }
}



private extension CanvasView {

    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }

}

