//
//  UploadImagesScreen.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 16.05.2024..
//

import SwiftUI
import PhotosUI

struct UploadImagesScreen: View {
    @State private var authorized = PHPhotoLibrary.authorizationStatus()
    @State private var pickerItems: [PhotosPickerItem] = []
    
    @State private var selectedImagesData: [Data] = []
    @State private var selectedImages: [UIImage] = []
    @State var showUploadAlert = false
    
    var body: some View {
        VStack {
            if authorized == .authorized {
                PhotosPicker("Select a picture", selection: $pickerItems, matching: .images)
                    .onChange(of: pickerItems) { pickerItems in
                        
                        Task {
                            selectedImages.removeAll()
                            for item in pickerItems {
                                item.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let imageData):
                                        if let imageData {
                                            self.selectedImages.append(UIImage(data: imageData)!)
                                            selectedImagesData.append(imageData)
                                        } else {
                                            print("No supported content type found.")
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
            }
            List {
                ForEach(selectedImages, id: \.self){ image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
            }
        }
        .toolbar {
            Button(action: {
                // upload chapter to the server
                showUploadAlert = true
                
            }) {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .alert("Upload chapter", isPresented: $showUploadAlert) {
            Button("Yes", action: {
                
                
                /* upload selected chapter to the server */
                let uploadMgr = UploadManager(chapter: Chapter(name: "x", date: Date(), description: ""), eventList: [])
                Task {
                    await uploadMgr.uploadImages(imgsData: selectedImagesData)
                }
                
            })
            Button("No", role: .cancel) {
                showUploadAlert = false
            }
        } message: {
            Text("Are you sure you want to upload selected images")
        }
    }
}
