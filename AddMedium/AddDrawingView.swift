//
//  AddDrawingView.swift
//  
//
//  Created by Simon Bestler on 17.04.23.
//

import SwiftUI

struct AddDrawingView: View {

    @EnvironmentObject var setupVm : SetupViewModel
    @Environment(\.dismiss) var dismiss

    let position: ContentPosition
    @Binding var previewImage: UIImage?

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    @State private var medium = ARImageMedium(position: .top)
    @State private var width: Double = 0.8
    @State private var height: Double = 0.45
    @State private var keepAspectRatio: Bool = true
    @State private var customSize: Bool = false
    @State private var choosenSize: PageSize = .A4
    @State private var isResizable: Bool = false

    private var saveDisabled: Bool {
        if previewImage == nil {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                SettingsForm()
            }
            .onAppear {
                medium.position = position
                refreshImage(previewImage)
            }
            .navigationTitle("Add Drawing")
            .toolbar {
                /*
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                        dismiss()
                    }
                }
                 */
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        updateSize()
                        setupVm.media[position] = medium
                        dismiss()
                    }
                    .disabled(saveDisabled)
                }
            }
            .onChange(of: previewImage, perform: { newValue in
                refreshImage(newValue)
            })
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }

    private func refreshImage(_ newValue: UIImage?){
        guard let newValue = newValue else {return}
        previewImage = newValue
        if newValue.imageOrientation == .right {
            medium.isPortraitMode = true
        }
        medium.previewImage = newValue
    }

    @ViewBuilder private func SettingsForm() -> some View {
        Form {
            Section {
                Toggle(isOn: $isResizable) {
                    Text("Allow resizing, repositioning and scaling in AR")
                }
                Toggle(isOn: $keepAspectRatio) {
                    Text("Keep aspect ratio")
                }
                Toggle(isOn: $customSize) {
                    Text("Custom Size")
                }
            } header: {
                Text("General Settings")
            }

            if customSize {
                Section {
                    TextField("Width", value: $width, formatter: formatter, prompt: Text("Size in meters"))
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Width (in meters)")
                }
                if !keepAspectRatio {
                    Section {
                        TextField("Height", value: $height, formatter: formatter, prompt: Text("Size in meters"))
                            .keyboardType(.decimalPad)
                    } header: {
                        Text("Height (in meters)")
                    }
                }
            } else {
                Section {
                    Picker("Choose format", selection: $choosenSize) {
                        ForEach(PageSize.allCases, id: \.self) { size in
                            Text(size.rawValue)
                        }
                    }
                } header: {
                    Text("Size")
                }
            }
        }
    }

    private func updateSize() {
        medium.isResizable = isResizable
        if keepAspectRatio {
            guard let image = medium.previewImage else {return}

            let imgWidth = image.size.width
            let imgHeight = image.size.height

            var targetWidth = 0.0

            if customSize {
                targetWidth = width
            } else {
                targetWidth = Double(choosenSize.getWidth())
            }

            let result = calcAspectKeepingWidthHeight(imgWidth: imgWidth, imgHeight: imgHeight, targetWidth: targetWidth)

            medium.width = result.0
            medium.height = result.1

        } else {
            medium.width = Float(width)
            medium.height = Float(height)
        }
    }


    private func calcAspectKeepingWidthHeight(imgWidth: Double, imgHeight: Double, targetWidth: Double) -> (Float, Float) {
        let scaleFactor = imgHeight/imgWidth
        let height = targetWidth * scaleFactor
        return (Float(targetWidth), Float(height))
    }

}



struct AddDrawingView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        AddDrawingView(position: .top, previewImage: .constant(nil))
            .environmentObject(envObject)
    }
}
