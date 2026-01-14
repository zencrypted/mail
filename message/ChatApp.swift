//  MessageApp.swift

import SwiftUI
import CoreData

@main
struct ChatApp: App {
    let persistenceController = PersistenceController.shared
    @State var selectedConversation: Conversation?

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                ConversationsView(
                    conversations: [
                        sampleConversation,
                        sampleLongConversation,
                        sampleGroupConversation
                    ],
                    selectedConversation: $selectedConversation
                )
            } detail: {
                if let selectedConversation {
                    MessageChatView(conversation: selectedConversation)
                } else {
                    ContentUnavailableView("Select a conversation", systemImage: "exclamationmark.bubble")
                }
            }
        }
    }
}
