//
//  AddMediumView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 05.04.23.
//

import SwiftUI

struct AddMediumView: View {

    var previewImage = Image(systemName: "photo")

    @State private var showingPopOver = false

    var body: some View {
        VStack {
            Spacer()
            VStack {
                /*
                previewImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                 */
            Button {
                showingPopOver.toggle()
            } label: {
                    Text(Image(systemName: "plus.circle"))
                    Text("Add new medium")
                }
            }
            .buttonStyle(.bordered)
            .popover(isPresented: $showingPopOver) {
                Text("Test")
        }
        Spacer()
        }
    }
}

struct AddMediumView_Previews: PreviewProvider {
    static var previews: some View {
        AddMediumView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
