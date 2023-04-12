//
//  SelectMenuView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 09.04.23.
//

import SwiftUI

struct SelectMenuView: View {

    let position: ContentPosition

    @EnvironmentObject var setupVm: SetupViewModel

    @State private var showingImageSheet = false
    @State private var showingVideoSheet = false

    var body: some View {

        VStack {
            if let medium = setupVm.media[position], medium != nil {
                if let image = medium!.previewImage{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
            Menu(){
                Button {
                    showingVideoSheet = true
                } label: {
                    Label("Video", systemImage: "play.rectangle")
                }
                Button {
                    showingImageSheet = true
                } label: {
                    Label("Image", systemImage: "photo")
                }
            } label: {
                Text(Image(systemName: "plus.circle"))
                Text("Add new medium")
            }
            .buttonStyle(.bordered)
            .sheet(isPresented: $showingImageSheet, content: {
                AddImageView(position: position)
            })
            .sheet(isPresented: $showingVideoSheet) {
                AddVideoView(position: position)
            }
        }

    }

}

struct SelectMenuView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        SelectMenuView(position: .top)
            .environmentObject(envObject)
    }
}
