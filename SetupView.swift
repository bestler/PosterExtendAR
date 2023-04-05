//
//  SetupView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 04.04.23.
//

import SwiftUI

struct SetupView: View {

    @State private var anchorImage: Image?
    @State private var inputAnchorImage: UIImage?
    @State private var showingImagePicker = false

    var body: some View {
        VStack {
            if let anchorImage {
                anchorImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            Button("Select Anchor Image") {
                showingImagePicker.toggle()
            }
            .buttonStyle(.borderedProminent)
            VStack {
                Text("Select here an image (e.g. a poster) that exists in the real world.")
                Text("The different views will be arranged around it.")
            }
            .font(.caption)
            .padding(.trailing)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputAnchorImage)
        }
        .onChange(of: inputAnchorImage) { _ in
            loadImage()
        }
    }

    func loadImage() {
        guard let inputAnchorImage = inputAnchorImage else {return}
        anchorImage = Image(uiImage: inputAnchorImage)
    }


}



struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
