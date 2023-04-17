//
//  SetupView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 04.04.23.
//

import SwiftUI

struct SetupView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject private var setupVm = SetupViewModel()

    var body: some View {
        NavigationStack {
            VStack() {
                SelectMenuView(position: .top)
                HStack() {
                    SelectMenuView(position: .left)
                    AnchorImageView()
                    SelectMenuView(position: .right)
                }
                SelectMenuView(position: .bottom)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        setupVm.showingARExperience = true
                    } label: {
                        Text("Show in AR")
                        Text((Image(systemName: "play.fill")))
                    }
                }
            }
            .navigationTitle("Create an AR Experience ✨")
            .fullScreenCover(isPresented: $setupVm.showingARExperience, content: {
                ZStack(alignment: .topTrailing){
                    setupVm.arExperience
                        .ignoresSafeArea(.container)
                    Button(){
                        setupVm.arExperience.stopPlayback()
                        setupVm.showingARExperience.toggle()
                    } label: {
                        Text(Image(systemName: "x.circle"))
                            .font(.title2)
                            .padding(7)
                    }
                }
            })
        }
        .environmentObject(setupVm)
    }
}


struct SetupView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        SetupView()
            .environmentObject(envObject)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
