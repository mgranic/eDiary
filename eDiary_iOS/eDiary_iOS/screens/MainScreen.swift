//
//  ContentView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import SwiftUI

struct MainScreen: View {
    @Environment(\.modelContext) var modelCtx
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
                .onAppear {
                    // update list of chapters
                    chapterManager.updateChapterList(modelCtx: modelCtx)
                }
                .sheet(isPresented: $showCreateChapterSheet, onDismiss: {
                    // update list of chapters
                    chapterManager.updateChapterList(modelCtx: modelCtx)
                }) {
                    // create chapter sheet
                    CreateChapterView()
                }
                Text("Chapter list")
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(.purple)
                List { //}($chapterManager.chapterList, editActions: .delete) { $chapter in
                    ForEach(chapterManager.chapterList) { chapter in
                        NavigationLink(destination: ChapterDetailsScreen()) {
                            HStack {
                                Text("\(chapter.name)")
                                    .font(.title3)
                                Spacer()
                                Text("\(chapter.date)")
                                    .font(.title3)
                            }
                            .contentShape(Rectangle())
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                chapterManager.deleteById(dbId: chapter.id, modelCtx: modelCtx)
                            }
                            
                        }
                    }
                    //.onDelete(perform: )
                }
                .listStyle(.inset)
                .alert(isPresented: $chapterManager.databaseOperationFailed) {
                    Alert(title: Text("Failed to complete!!! Something went wrong with the database"))
                }
            }
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
