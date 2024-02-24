//
//  CreateChapterView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import SwiftUI

struct CreateChapterView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx
    @State var name: String = ""
    @State var date: Date = Date()
    
    var body: some View {
        Form {
            Section {
                HStack(alignment: .center) {
                    Text("Name")
                    TextField("Name", text: $name)
                }
            }
            Section {
                DatePicker (
                    "Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
            }
            Section {
                HStack {
                    Section {
                        Button("Submit") {
                            let chapterManager = ChapterManager()
                            chapterManager.createChapter(name: name, date: date, modelCtx: modelCtx)
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
}

#Preview {
    CreateChapterView()
}
