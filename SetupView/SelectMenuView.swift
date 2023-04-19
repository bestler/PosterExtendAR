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
    @State private var showingDrawing = false

    var body: some View {
        VStack {
            if let medium = setupVm.media[position], medium != nil {
                if let image = medium!.previewImage{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                        .frame(minWidth: 50, idealWidth: 100, maxWidth: 300)
                    if medium is ARVideoMedium {
                        Label("Video", systemImage: "play.rectangle")
                            .labelStyle(CustomBackgroundLabelStyle(color: .mint))
                    } else if medium is ARImageMedium {
                        Label("Image", systemImage: "photo")
                            .labelStyle(CustomBackgroundLabelStyle(color: .orange))
                    }
                }
            } else {
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
                    Button {
                        showingDrawing = true
                    } label: {
                        Label("Drawing", systemImage: "pencil.and.ruler")
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
                .sheet(isPresented: $showingDrawing) {
                    DrawingView(position: position)
                        .interactiveDismissDisabled(true)
                }
            }
        }
        .padding()
    }

}

struct CustomBackgroundLabelStyle: LabelStyle {

    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .padding(4)
            .background(content: {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(color).opacity(0.2)
            })
    }
}


struct SelectMenuView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        SelectMenuView(position: .top)
            .environmentObject(envObject)
    }
}
