//
//  EventFormView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 13.03.2024..
//

import SwiftUI
import PhotosUI

struct EventFormView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx
    
    @Binding var name: String
    @Binding var date: Date
    @Binding var description: String
    
    @State private var authorized = PHPhotoLibrary.authorizationStatus()
    @State private var pickerItem: PhotosPickerItem?
    
    //@Binding private var selectedImageData: Data?
    @State private var selectedImage: Image?
    
    @State private var showCamera = false
    @State private var selectedCameraImage: UIImage?
    @State var isCameraAuthorized = false//AVAuthorizationStatus.notDetermined
    
    var chapterId: UUID?
    var eventId: UUID?
    var isCreateEvent: Bool
    
    // edit event
    init(chapterId: UUID? = nil, eventId: UUID? = nil, name: Binding<String> = .constant(""), date: Binding<Date> = .constant(Date()), description: Binding<String> = .constant(""), selectedImgData: Binding<Data?> = .constant(nil), isCreateEvent: Bool) {
        self.chapterId = chapterId
        self.eventId = eventId
        self._name = name
        self._date = date
        self._description = description
        //self._selectedImageData = selectedImgData
        self.isCreateEvent = isCreateEvent
        
        let imgManager = ImageManager()
        self._selectedImage = State(initialValue: imgManager.imageDataToImage(imgData: selectedImgData.wrappedValue))
        
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack(alignment: .center) {
                        Text("Name")
                        TextField("Name", text: $name)
                    }
                }
                Section(header: Text("Chapter description")) {
                    TextEditor(text: $description)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .navigationTitle("Description")
                        .frame(minHeight: UIScreen.main.bounds.height * 0.3, maxHeight: UIScreen.main.bounds.height * 0.3)
                }
                Section {
                    DatePicker (
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                }
                
                Section {
                    if authorized == .authorized {
                        PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
                            .onChange(of: pickerItem) {
                                Task {
                                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                                }
                            }
                    }
                    selectedImage?
                            .resizable()
                            .scaledToFit()
                }
                
                VStack {
                    //if let selectedCameraImage {
                    //    Image(uiImage: selectedCameraImage)
                    //        .resizable()
                    //        .scaledToFit()
                    //}
                    
                    if isCameraAuthorized == true {
                        Button("Open camera") {
                            self.showCamera.toggle()
                        }
                        .fullScreenCover(isPresented: self.$showCamera) {
                            accessCameraView(selectedImage: self.$selectedImage, selectedCameraImage: self.$selectedCameraImage)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Section {
                            Button("Submit") {
                                Task {
                                    let eventManager = EventManager()
                                    if (isCreateEvent) {
                                        await eventManager.createEventDispatcher(chapterId: chapterId!, name: name, date: date, description: description, imgPicker: pickerItem, imgUiImg: selectedCameraImage, modelCtx: modelCtx)
                                    } else {
                                        await eventManager.editEventDispatcher(eventId: eventId!, name: name, date: date, description: description, imgPhotosPicker: pickerItem, imgUiImage: selectedCameraImage, modelCtx: modelCtx)
                                        // update selectedImageData to reflect it on details page on close if new image is selected
                                        //if let newPhotosPickerItem = pickerItem {
                                        //    let imgManager = ImageManager()
                                        //    selectedImageData = await imgManager.photosPickerToData(img: newPhotosPickerItem)
                                        //}
                                    }
                
                                }
                                dismiss()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .buttonBorderShape(.capsule)
                        }
                        .disabled(self.name.isEmpty)
                        Button("Cancel") {
                            //presentSheet = false
                            dismiss()
                        }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .buttonBorderShape(.capsule)
                    }
                }
            }
        }
        .onAppear {
            // request gallery access
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.authorized = status
                }
            }
            
            authorizeCamera()
        }
    }
    
    private func authorizeCamera() {
        Task {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            isCameraAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isCameraAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
        }
    }
}

struct accessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: Image?
    @Binding var selectedCameraImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: accessCameraView
    
    init(picker: accessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        //self.picker.selectedImage = selectedImage
        self.picker.selectedImage = Image(uiImage: selectedImage)
        self.picker.selectedCameraImage = selectedImage
        //self.picker.pickerItem = info[.originalImage] as? PhotosPickerItem
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

#Preview {
    EventFormView(chapterId: UUID(uuidString: "Test uuid")!, isCreateEvent: true)
}
