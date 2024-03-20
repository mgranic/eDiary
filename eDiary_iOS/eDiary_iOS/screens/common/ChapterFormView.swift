//
//  ChapterFormView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 20.03.2024..
//

import SwiftUI

struct ChapterFormView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx
    @Binding var name: String
    @Binding var date: Date
    @Binding var description: String
    
    var chapterId: UUID?
    var isCreateChapter: Bool
    
    init(chapterId: UUID? = nil, name: Binding<String>, date: Binding<Date>, description: Binding<String>, isCreateChapter: Bool) {
        self._name = name
        self._date = date
        self._description = description
        self.isCreateChapter = isCreateChapter
        self.chapterId = chapterId
    }
    
    var body: some View {
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
                HStack {
                    Section {
                        Button("Submit") {
                            let chapterManager = ChapterManager()
                            if (isCreateChapter) {
                                chapterManager.createChapter(name: name, date: date, description: description, modelCtx: modelCtx)
                            } else {
                                chapterManager.editChapter(chapterId: chapterId!, name: name, date: date, description: description, modelCtx: modelCtx)
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
}
