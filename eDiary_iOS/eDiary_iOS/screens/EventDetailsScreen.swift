//
//  EventDetailsScreen.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 08.03.2024..
//

import SwiftUI

struct EventDetailsScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State var name: String
    @State var description: String
    @State var date: Date
    @State var img: Data?
    var id: UUID
    
    init(name: State<String>, desc: State<String>, date: State<Date>, img: State<Data?>, id: UUID) {
        self._name = name
        self._description = desc
        self._date = date
        self._img = img
        self.id = id
        
    }
    var body: some View {
        ScrollView {
            VStack {
                Text("Title \(name)")
                    .onTapGesture {
                        print("Tapped \(name)")
                    }
                Text(description)
                    .onTapGesture {
                        print("Tapped \(description)")
                    }
                DatePicker (
                    "Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .onChange(of: date) {
                    print(date)
                }
                VStack {
                    if let imgData = img {
                        if let image = UIImage(data: imgData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: UIScreen.main.bounds.width * 0.9, maxWidth: UIScreen.main.bounds.width * 0.9, minHeight: UIScreen.main.bounds.height * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
                                .border(.blue, width: 5)
                                .cornerRadius(20)
                                .onTapGesture {
                                    print("Tapped on image")
                                }
                        }
                    }
                }
            }
        }
        .toolbar {
            Button(action: {
                // delete chapter and show dialog "are you sure"
                print("delete button pressed")
                dismiss()
            }) {
                Image(systemName: "trash")
            }
        }
    }
}
