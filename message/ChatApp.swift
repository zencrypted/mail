// ChatApp.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI
import CoreData

@main
struct ChatApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var erpState = ERPState()

    var body: some Scene {
        WindowGroup {
            Group {
                if erpState.isLoggedIn {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(erpState)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .preferredColorScheme(erpState.selectedTheme.colorScheme)
        }
        .commands {
            // macOS Window Management & Shortcuts
            CommandGroup(replacing: .newItem) {
                Button("New Document") {
                    // Trigger new document logic
                }
                .keyboardShortcut("n", modifiers: .command)
                
                Button("Open File...") {
                    // Trigger file open
                }
                .keyboardShortcut("o", modifiers: .command)
            }
            
            CommandMenu("ERP Users") {
                Button("Switch User...") {
                    erpState.logout()
                }
                .keyboardShortcut("u", modifiers: [.command, .shift])
            }
            
            CommandGroup(replacing: .windowList) {
                Button("Show Inboxes") {
                    // Handle window bring to front
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Show Forms") {
                    // Handle window bring to front
                }
                .keyboardShortcut("2", modifiers: .command)
            }
        }
    }
}
