//
//  DrawingView.swift
//  
//
//  Created by Simon Bestler on 17.04.23.
//

import SwiftUI
import PencilKit

struct DrawingView: View {

    let position: ContentPosition
    @State private var canvasView = PKCanvasView()
    @State private var image: UIImage?
    @State private var showingSettingsScreen = false
    @State private var showingToolPicker = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            CanvasView(showingToolPicker: $showingToolPicker, canvasView: $canvasView)
                .navigationTitle("Draw")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(uiColor: .systemGroupedBackground), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Next") {
                            showingToolPicker = false
                            image = canvasView.asImage()
                            showingSettingsScreen.toggle()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    print("onAppear called")
                    showingToolPicker = true
                }
                .navigationDestination(isPresented: $showingSettingsScreen) {
                    AddDrawingView(position: position, previewImage: $image)
                }
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(position: .top)
    }
}
