//
//  SwiftUIView.swift
//  
//
//  Created by Simon Bestler on 12.04.23.
//

import SwiftUI
import ARKit

struct AddAnchorView: View {

    @EnvironmentObject var setupVm : SetupViewModel
    @Environment(\.dismiss) var dismiss

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()


    @State private var progress: Progress?

    @State private var isError: Bool = false
    @State private var showingImagePicker: Bool = false
    @State private var showingScanner: Bool = false
    @State private var previewImage: UIImage?

    @State private var width: Double = 0.8
    @State private var height: Double = 0.45
    @State private var customSize: Bool = false
    @State private var choosenSize: PageSize = .DINA4


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
                    VStack {
                        Button {
                            showingImagePicker.toggle()
                        }label: {
                            Text("Select Image from Library")
                        }
                        Text("or")
                        Button {
                            showingScanner.toggle()
                        }label: {
                            Text("Scan")
                        }
                    }
                    .fullScreenCover(isPresented: $showingScanner) {
                        Scanner(image: $previewImage, showingScanner: $showingScanner)
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $previewImage, progress: $progress, showingPicker: $showingImagePicker)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
                SettingsForm()
            }
            .alert("Image can't be used as an anchor. Please choose another one.", isPresented: $isError, actions: {
                Button("OK") {
                    setupVm.anchorImage = nil
                    previewImage = nil
                }
            })
            .navigationTitle("Add Image")
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        setupVm.anchorImage = previewImage
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
                validateImage(newValue)
                previewImage = newValue
            })
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }

    private func validateImage(_ image: UIImage) {
        if let cgImage = image.cgImage {
            let possibleRefImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation(image.imageOrientation), physicalWidth: 0.4)
            possibleRefImage.validate { (error) in
                if error != nil {
                    isError = true
                }
            }
        }
    }

    @ViewBuilder private func SettingsForm() -> some View {
        Form {
            Section {
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
                Section {
                    TextField("Height", value: $height, formatter: formatter, prompt: Text("Size in meters"))
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Height (in meters)")
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


}

struct AddAnchorView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        AddAnchorView()
            .environmentObject(envObject)
    }
}
