//
//  SetupView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 04.04.23.
//

import SwiftUI

struct SetupView: View {

    @StateObject private var setupVm = SetupViewModel()

    @State private var showingImagePicker = false
    @State private var showingARExperience = false


    var body: some View {
        NavigationStack {
            VStack() {
                AddMediumView()
                HStack() {
                    AddMediumView()
                    VStack {
                        if let anchorImage = setupVm.anchorImage {
                            anchorImage
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 300, maxHeight: 300)
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
                    AddMediumView()
                }
                AddMediumView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingARExperience.toggle()
                        //arExperience.setRefImage(inputAnchorImage!)
                    } label: {
                        Text("Show in AR")
                        Text((Image(systemName: "play.fill")))
                    }
                }
            }
            .navigationTitle("PosterExtendAR")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $setupVm.inputAnchorImage)
            }
            .fullScreenCover(isPresented: $showingARExperience, content: {
                setupVm.arExperience
            })
            .onChange(of: setupVm.inputAnchorImage) { _ in
                setupVm.loadImage()
        }
        }
    }
}


struct AnchorImageView: View {

    @Binding var anchorImage: Image?

    @State private var inputAnchorImage: UIImage?

    @State private var showingImagePicker = false

    var body: some View {
        Text("Test")
    }

}


struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
