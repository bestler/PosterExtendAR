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
    @State private var showingARExperience = false

    let arExperience = ARViewContainer()

    var body: some View {
        NavigationStack {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingARExperience.toggle()
                        arExperience.setRefImage(inputAnchorImage!)
                    } label: {
                        Text("Show in AR")
                        Text((Image(systemName: "play.fill")))
                    }
                }
            }
            .navigationTitle("PosterExtendAR")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputAnchorImage)
            }
            .fullScreenCover(isPresented: $showingARExperience, content: {
                arExperience
            })
            .onChange(of: inputAnchorImage) { _ in
                loadImage()
        }
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
