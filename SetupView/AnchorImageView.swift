//
//  AnchorImageView.swift
//  
//
//  Created by Simon Bestler on 09.04.23.
//

import SwiftUI

struct AnchorImageView: View {

    @EnvironmentObject var setupVm : SetupViewModel

    @State private var progress: Progress?

    @State private var showingAnchorImagePicker = false
    @State private var inputAnchorImage: UIImage?

    var body: some View {
        VStack {
            if let anchorImage = setupVm.anchorImage {
                Image(uiImage: anchorImage)
                    .resizable()
                    .scaledToFit()
                    .border(.black)
                    .frame(minWidth: 200, idealWidth: 400, maxWidth: 500)
                    .padding()
                Label("Anchor", systemImage: "dot.squareshape.split.2x2")
                    .labelStyle(CustomBackgroundLabelStyle(color: .pink))
            }else {
                VStack {
                    Button("Select Anchor Image") {
                        showingAnchorImagePicker.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    VStack(alignment: .leading) {
                        Text("1. Select here an image (e.g. a poster) that exists in the real world.")
                        Text("2. Arrange different views around that central image to provide more informations.")
                    }
                    .font(.caption)
                    .padding(.trailing)
                }
                //.padding(40)
            }
        }
        .sheet(isPresented: $showingAnchorImagePicker) {
            AddAnchorView()
        }
        /*
         #if DEBUG
         .onAppear{
         loadImage(UIImage(named: "London_Tower"))
         }
         #endif
         */
    }

    private func loadImage(_ image : UIImage?) {
        guard let image = image else {return}
        setupVm.anchorImage = image
        setupVm.arExperience.setRefImage(image)
    }

}

struct AnchorImageView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        AnchorImageView()
            .environmentObject(envObject)
    }
}
