//
//  DrawingView.swift
//  
//
//  Created by Simon Bestler on 17.04.23.
//

import SwiftUI
import PencilKit

struct DrawingView: View {

    @State private var canvasView = PKCanvasView()

    var body: some View {
        NavigationStack {
            CanvasView(canvasView: $canvasView)
                .border(.black)
                .navigationTitle("Draw")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Use") {

                        }
                    }
                }
        }

    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
