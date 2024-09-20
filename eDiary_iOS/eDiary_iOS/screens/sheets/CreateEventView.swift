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
    
    var chapterId: UUID
    
    init(chapterId: UUID) {
        self.chapterId = chapterId
    }
    
    var body: some View {
        EventFormView(chapterId: chapterId, name: $name, date: $date, description: $description, selectedImgData: $selectedImage, isCreateEvent: true)
    }
}

#Preview {
    CreateEventView(chapterId: UUID(uuidString: "Test uuid")!)
}
