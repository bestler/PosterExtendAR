//
//  SetupView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 04.04.23.
//

import SwiftUI

struct SetupView: View {

    @StateObject private var setupVm = SetupViewModel()

    @State private var showingARExperience = false

    var body: some View {
        NavigationStack {
            VStack() {
                AddMediumView()
                HStack() {
                    AddMediumView()
                    AnchorImageView(setupVm: setupVm)
                    AddMediumView()
                }
                AddMediumView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingARExperience.toggle()
                    } label: {
                        Text("Show in AR")
                        Text((Image(systemName: "play.fill")))
                    }
                }
            }
            .navigationTitle("PosterExtendAR")
            .fullScreenCover(isPresented: $showingARExperience, content: {
                setupVm.arExperience
            })
            .onChange(of: setupVm.inputAnchorImage) { newValue in
                setupVm.loadImage(newValue)
        }
        }
        #if DEBUG
        .onAppear{
            setupVm.loadImage(UIImage(named: "NCX-Poster"))
        }
        #endif
    }
}


struct AnchorImageView: View {

    @ObservedObject var setupVm : SetupViewModel

    @State private var showingImagePicker = false

    var body: some View {
        VStack {
            if let anchorImage = setupVm.anchorImage {
                anchorImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 500, maxHeight: 500)
                    .border(.black)
                    .padding()
            }else {
                VStack {
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
                .padding(40)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $setupVm.inputAnchorImage)
        }
    }
}


struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
