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
    @State private var image: UIImage? = UIImage(named: "NCX-Poster")
    @State private var showingSettingsScreen = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            CanvasView(canvasView: $canvasView)
                .border(.black)
                .navigationTitle("Draw")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Next") {
                            image = canvasView.asImage()
                            showingSettingsScreen.toggle()
                        }
                    }
                }
                .navigationDestination(isPresented: $showingSettingsScreen) {
                    AddDrawingView(position: .top, previewImage: $image)
                }
        }

    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
