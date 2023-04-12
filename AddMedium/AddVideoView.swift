//
//  AddVideoView.swift
//  PosterExtendAR
//
//  Created by Simon Bestler on 05.04.23.
//

import SwiftUI
import AVFoundation


struct AddVideoView: View {

    @EnvironmentObject var setupVm : SetupViewModel
    @Environment(\.dismiss) var dismiss

    let position: ContentPosition

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    @State private var progress: Progress?
    @State private var showingPicker = false
    @State private var videoURL: URL?
    @State private var previewImage: UIImage?

    @State private var width: Double = 0.8
    @State private var heigt: Double = 0.45
    @State private var keepAspectRatio: Bool = true
    @State private var isSound: Bool = true
    @State private var autoPlay: Bool = true

    private var saveDisabled: Bool {
        if previewImage != nil, videoURL != nil {
            return false
        }
        else {
            return true
        }
    }

    @State private var medium: ARVideoMedium?


    var body: some View {
        NavigationStack {
            VStack {
                if let progress, !progress.isFinished{
                    ProgressView("Loading Video...")
                }
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Text(videoURL?.absoluteString ?? "")
                } else {
                    Button {
                        showingPicker.toggle()
                    }label: {
                        Text("Select Video")
                    }
                    .sheet(isPresented: $showingPicker) {
                        VideoPicker(url: $videoURL, progress: $progress)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
                SettingsForm()
            }
            .navigationTitle("Add Video")
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        updateVideoMedium()
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
            .navigationBarTitleDisplayMode(.inline)
                .onChange(of: videoURL) { newURL in
                    if let newURL {
                        print("New Url")
                        medium = ARVideoMedium(position: .top, width: 0.45, height: 0.8)
                        medium?.url = newURL
                        let image = createPreview(url: newURL)
                        if let image {
                            print("Created Image sucessfully")
                            previewImage = image
                            medium?.previewImage = image
                        }
                    }
                }
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }

    @ViewBuilder private func SettingsForm() -> some View {
        Form {
            Section {
                Toggle(isOn: $autoPlay) {
                    Text("Autoplay video")
                }
                Toggle(isOn: $isSound) {
                    Text("Playback with sound")
                }
                Toggle(isOn: $keepAspectRatio) {
                    Text("Keep aspect ratio")
                }

            } header: {
                Text("General Settings")
            }
            Section {
                TextField("Width", value: $width, formatter: formatter, prompt: Text("Size in meters"))
                    .keyboardType(.decimalPad)
            } header: {
                Text("Width (in meters)")
            }
            if !keepAspectRatio {
                Section {
                    TextField("Height", value: $heigt, formatter: formatter, prompt: Text("Size in meters"))
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Height (in meters)")
                }
            }
        }
    }


    private func updateVideoMedium() {
        updateSizeAccordingToScale()
        medium?.autoPlayEnabled = autoPlay
        medium?.playBackWithSound = isSound
    }

    private func updateSizeAccordingToScale(){
        guard let previewImage = previewImage else {return}

        let imgWidth = previewImage.size.width
        let imgHeigt = previewImage.size.height
        if imgWidth < imgHeigt {
            medium?.isPortraitMode = true
        }
        if keepAspectRatio {
            let scaleFactor = imgHeigt / imgWidth
            medium?.height = Float(width * scaleFactor)
        } else {
            medium?.height = Float(heigt)
        }
        medium?.width = Float(width)
    }


    private func createPreview(url : URL) -> UIImage? {
        let asset = AVAsset(url: url)
        do {
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

struct VideoView_Previews: PreviewProvider {

    static let envObject = SetupViewModel()

    static var previews: some View {
        AddVideoView(position: .top)
            .environmentObject(envObject)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
