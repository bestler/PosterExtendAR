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

    @State private var showingSheet = false

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
                    showingSheet.toggle()
                } label: {
                    Label("Video", systemImage: "play.rectangle")
                }
            } label: {
                Text(Image(systemName: "plus.circle"))
                Text("Add new medium")
            }
            .buttonStyle(.bordered)
            .sheet(isPresented: $showingSheet) {
                AddVideoView(position: position)
        }
        }
    }
}

struct SelectMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SelectMenuView(position: .top)
    }
}
