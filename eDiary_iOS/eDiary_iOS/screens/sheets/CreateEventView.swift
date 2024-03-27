//
//  CreateEventView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 04.03.2024..
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
    //@Environment(\.dismiss) var dismiss
    //@Environment(\.modelContext) var modelCtx
    @State var name: String = ""
    @State var date: Date = Date()
    @State var description: String = ""
    
    //@State private var authorized = PHPhotoLibrary.authorizationStatus()
    //@State private var pickerItem: PhotosPickerItem?
    @State var selectedImage: Data?
    
    var chapter: Chapter
    
    init(chapter: Chapter) {
        self.chapter = chapter
    }
    
    var body: some View {
        EventFormView(chapter: chapter, name: $name, date: $date, description: $description, selectedImgData: $selectedImage, isCreateEvent: true)
        //VStack {
        //    Form {
        //        Section {
        //            HStack(alignment: .center) {
        //                Text("Name")
        //                TextField("Name", text: $name)
        //            }
        //        }
        //        Section(header: Text("Chapter description")) {
        //            TextEditor(text: $description)
        //                .foregroundStyle(.secondary)
        //                .padding(.horizontal)
        //                .navigationTitle("Description")
        //                .frame(minHeight: UIScreen.main.bounds.height * 0.3, maxHeight: UIScreen.main.bounds.height * 0.3)
        //        }
        //        Section {
        //            DatePicker (
        //                "Date",
        //                selection: $date,
        //                displayedComponents: [.date]
        //            )
        //        }
        //
        //        if authorized == .authorized {
        //            Section {
        //                PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
        //                    .onChange(of: pickerItem) {
        //                        Task {
        //                            selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
        //                        }
        //                    }
        //                //if selectedImage != nil {
        //                selectedImage?
        //                        .resizable()
        //                        .scaledToFit()
        //                //}
        //            }
        //        }
        //
        //        Section {
        //            HStack {
        //                Section {
        //                    Button("Submit") {
        //                        Task {
        //                            let eventManager = EventManager()
        //                            await eventManager.createEvent(chapterId: chapterId, name: name, date: date, description: description, img: pickerItem, modelCtx: modelCtx)
        //                        }
        //                        dismiss()
        //                    }
        //                    .buttonStyle(.bordered)
        //                    .controlSize(.large)
        //                    .buttonBorderShape(.capsule)
        //                }
        //                .disabled(self.name.isEmpty)
        //                Button("Cancel") {
        //                    //presentSheet = false
        //                    dismiss()
        //                }
        //                    .buttonStyle(.bordered)
        //                    .controlSize(.large)
        //                    .buttonBorderShape(.capsule)
        //            }
        //        }
        //    }
        //}
        //.onAppear {
        //    // request gallery access
        //    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
        //        DispatchQueue.main.async {
        //            self.authorized = status
        //        }
        //    }
        //}
    }
}
