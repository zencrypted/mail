//  MessageApp.swift

import SwiftUI
import CoreData

@main
struct MessageApp: App {
    let persistenceController = PersistenceController.shared
    @State var selection: SidebarSelection?
    
    var body: some Scene {
            WindowGroup {
                NavigationSplitView {
                    ConversationListView(
                        conversations: [
                            sampleConversation,
                            sampleLongConversation,
                            sampleGroupConversation
                        ],
                        selection: $selection
                    )
                } detail: {
                    switch selection {
                    case .newMessage:
                        NewMessage(selection: $selection)
                    case .conversation(let conversation):
                        ChatThreadView(conversation: conversation)
                    case nil:
                        ContentUnavailableView("Select a conversation", systemImage: "exclamationmark.bubble")
                    }
                }
            }
        }
    
}
