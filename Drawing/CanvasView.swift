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

    @Binding var showingToolPicker: Bool
    @Binding var canvasView: PKCanvasView
    @State var toolPicker = PKToolPicker()

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.backgroundColor = .secondarySystemBackground
        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        #if targetEnvironment(simulator)
        canvasView.drawingPolicy = .anyInput
        #endif
        showToolPicker()
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if showingToolPicker {
            canvasView.becomeFirstResponder()
            toolPicker.setVisible(true, forFirstResponder: canvasView)
        }
    }
}



private extension CanvasView {

    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }

}

