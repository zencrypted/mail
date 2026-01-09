// ConversationListView.swift

import SwiftUI

struct ConversationListView: View {
    let conversations: [Conversation]
    @Binding var selection: SidebarSelection?
    @State var textToSearch = ""

    var filteredConversations: [Conversation] {
        if textToSearch.isEmpty {
            return conversations
        }
        return conversations.filter {
            $0.messages.contains(where: { $0.text.localizedCaseInsensitiveContains(textToSearch) }) ||
            $0.participants.contains(where: { $0.firstName.localizedCaseInsensitiveContains(textToSearch) }) ||
            $0.participants.contains(where: { $0.lastName.localizedCaseInsensitiveContains(textToSearch) })
        }
    }

    init(
        conversations: [Conversation],
        selection: Binding<SidebarSelection?>
    ) {
        self.conversations = conversations
        self._selection = selection
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(filteredConversations) { conversation in
                ConversationListCell(conversation: conversation)
                    .tag(SidebarSelection.conversation(conversation))
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            // mark conversation as unread
                        } label: {
                            Image(systemName: "message.badge")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            // Delete conversation
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        Button {
                            // turn of notifications
                        } label: {
                            Image(systemName: "bell.slash")
                        }
                        .tint(.purple)
                    }
            }
        }
        .searchable(text: $textToSearch)
        .navigationTitle("Messages")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    selection = .newMessage
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ConversationListView(conversations: [
            sampleConversation,
            sampleConversation,
            sampleConversation
        ], selection: .constant(nil))
    }
}
