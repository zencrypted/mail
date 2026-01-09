//  MessageApp.swift

import SwiftUI
import CoreData

@main
struct MessageApp: App {
    let persistenceController = PersistenceController.shared
    @State var selectedConversation: Conversation?

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                ConversationListView(
                    conversations: [
                        sampleConversation,
                        sampleLongConversation,
                        sampleGroupConversation
                    ],
                    selectedConversation: $selectedConversation
                )
            } detail: {
                if let selectedConversation {
                    ChatThreadView(conversation: selectedConversation)
                } else {
                    ContentUnavailableView("Select a conversation", systemImage: "exclamationmark.bubble")
                }
            }
        }
    }
}
