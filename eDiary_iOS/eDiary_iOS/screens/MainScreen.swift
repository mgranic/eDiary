//
//  ContentView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import SwiftUI

struct MainScreen: View {
    @StateObject var chapterManager = ChapterManager()
    @State var showCreateChapterSheet: Bool = false   // toggle create chapter form
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    // show sheet to create new chapter
                    showCreateChapterSheet.toggle()
                }) {
                    Text("Add chapter")
                        .font(.system(.title2, design: .rounded))
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(isPresented: $showCreateChapterSheet, onDismiss: { /*update list of chapters*/ }) {
                    // create chapter sheet
                    CreateChapterView()
                }
                Text("Chapter list")
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(.purple)
                List {
                    ForEach(chapterManager.chapterList) { chapter in
                        HStack {
                            Text("\(chapter.name)")
                                .font(.title3)
                            Spacer()
                            Text("\(chapter.date)")
                                .font(.title3)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // navigate to ChapterDetailsScreen
                            // for navigation add navigation link or use this to show sheet
                        }
                    }
                }
                .listStyle(.inset)
            }
            .onAppear(perform: {
                // initialize code needed for this screen to displaz properly
            })
            .padding()
        }
        .toolbar {
            //NavigationLink(destination: SearchView(modelCtx: modelCtx)) {
            //    Image(systemName: "magnifyingglass")
            //}
            //Menu {
            //    NavigationLink(destination: ExpenseStatsView()) {
            //        Text("Expense Stats")
            //    }
            //    NavigationLink(destination: ScheduleExpenseView()) {
            //        Text("Schedule expense")
            //    }
            //    NavigationLink(destination: SettingsView()) {
            //        Text("Settings")
            //    }
            //} label: {
            //    Label("Menu", systemImage: "ellipsis.circle")
            //}
        }
    }
}

#Preview {
    MainScreen()
}
