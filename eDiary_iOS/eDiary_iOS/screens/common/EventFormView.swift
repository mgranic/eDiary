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
    
    @Binding private var selectedImageData: Data?
    @State private var selectedImage: Image?
    
    var chapter: Chapter?
    var eventId: UUID?
    var isCreateEvent: Bool
    
    // create event
    //init(chapterId: UUID? = nil, eventId: UUID? = nil, name: Binding<String> = .constant(""), date: Binding<Date> = .constant(Date()), description: Binding<String> = .constant(""), selectedImgData: Binding<Data?> = .constant(nil), isCreateEvent: Bool) {
    //    self.chapterId = chapterId
    //    self.eventId = eventId
    //    self._name = name
    //    self._date = date
    //    self._description = description
    //    self._selectedImageData = selectedImgData
    //    self.isCreateEvent = isCreateEvent
    //
    //    let imgManager = ImageManager()
    //    self._selectedImage = State(initialValue: imgManager.imageDataToImage(imgData: selectedImgData.wrappedValue))
    //}
    
    // edit event
    init(chapter: Chapter? = nil, eventId: UUID? = nil, name: Binding<String> = .constant(""), date: Binding<Date> = .constant(Date()), description: Binding<String> = .constant(""), selectedImgData: Binding<Data?> = .constant(nil), isCreateEvent: Bool) {
        self.chapter = chapter
        self.eventId = eventId
        self._name = name
        self._date = date
        self._description = description
        self._selectedImageData = selectedImgData
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
                
                Section {
                    HStack {
                        Section {
                            Button("Submit") {
                                Task {
                                    let eventManager = EventManager()
                                    if (isCreateEvent) {
                                        await eventManager.createEvent(chapter: chapter!, name: name, date: date, description: description, img: pickerItem, modelCtx: modelCtx)
                                    } else {
                                        await eventManager.editEvent(eventId: eventId!, name: name, date: date, description: description, img: pickerItem, modelCtx: modelCtx)
                                        // update selectedImageData to reflect it on details page on close if new image is selected
                                        if let newPhotosPickerItem = pickerItem {
                                            let imgManager = ImageManager()
                                            selectedImageData = await imgManager.photosPickerToData(img: newPhotosPickerItem)
                                        }
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
        }
    }
}
