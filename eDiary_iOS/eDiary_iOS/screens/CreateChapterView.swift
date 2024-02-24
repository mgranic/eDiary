//
//  CreateChapterView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import SwiftUI

struct CreateChapterView: View {
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var date: Date = Date()
    //@Binding var presentSheet: Bool
    
    //init(presentSheet: Binding<Bool>) {
    //    self._presentSheet = presentSheet
    //}
    
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
