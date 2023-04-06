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
            .sheet(isPresented: $showingPopOver) {
                SelectMediumSheet()
        }
        }
    }
}

struct SelectMediumSheet: View {

    @State private var selectedChoice = 0

    private let options = ["Image", "Video", "Drawing"]

    var body: some View {
        NavigationStack {
            Picker("Media Type", selection: $selectedChoice) {
                ForEach(0 ..< options.count, id: \.self) { index in
                    Text(options[index])
                        .tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .navigationTitle("Select Mediatype")
            .navigationBarTitleDisplayMode(.inline)
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
