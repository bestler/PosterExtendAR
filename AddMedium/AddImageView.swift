//
//  SwiftUIView.swift
//  
//
//  Created by Simon Bestler on 09.04.23.
//

import SwiftUI

struct AddImageView: View {

    @EnvironmentObject var setupVm : SetupViewModel
    @Environment(\.dismiss) var dismiss

    let position: ContentPosition

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    @State private var medium = ARImageMedium(position: .top)

    @State private var progress: Progress?

    @State private var showingImagePicker: Bool = false
    @State private var previewImage: UIImage?

    @State private var width: Double = 0.8
    @State private var height: Double = 0.45
    @State private var keepAspectRatio: Bool = true
    @State private var customSize: Bool = false
    @State private var choosenSize: PageSize = .DINA4
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
                if let progress, !progress.isFinished{
                    ProgressView("Loading Image...")
                }
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    Button {
                        showingImagePicker.toggle()
                    }label: {
                        Text("Select Image")
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $previewImage, progress: $progress, showingPicker: $showingImagePicker)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
                SettingsForm()
            }
            .onAppear {
                medium.position = position
            }
            .navigationTitle("Add Image")
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        updateSize()
                        setupVm.media[position] = medium
                        dismiss()
                    }
                    .disabled(saveDisabled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: previewImage, perform: { newValue in
                guard let newValue = newValue else {return}
                previewImage = newValue
                if newValue.imageOrientation == .right {
                    medium.isPortraitMode = true
                }
                medium.previewImage = newValue
            })
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
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

struct AddImageView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        AddImageView(position: ContentPosition.top)
            .environmentObject(envObject)
    }
}
