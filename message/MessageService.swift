// MessageService.swift

import Foundation
internal import Combine

@MainActor
final class MessageService: ObservableObject {
    static let shared = MessageService()
    
    private(set) var peerManager: MessagePeer?
    private(set) var groupManager: MessageGroup?
    
    var peers: [Participant] = []
    var conversations: [Conversation] = []
    
    private init() {}
    
    func start() {
        peerManager = MessagePeer(service: self)
        groupManager = MessageGroup(service: self)
        
        Task { await peerManager?.startListening() }
        Task { await groupManager?.startListening() }
    }
    
    // Called from background → must be @MainActor
    func appendMessage(_ message: Message, to conversationId: String) {
        // find → update or create conversation
        if conversations.firstIndex(where: { $0.id == conversationId }) != nil {
            // var conv = conversations[idx]
            // conv.messages.append(message)
            // conv.updatedAt = message.createdAt
            // conv.isRead = (message.author == sampleLoggedInUser) // optimistic
            // conversations[idx] = conv
        } else {
            // create new conversation — you may want different logic for group vs 1:1
            let newConv = Conversation(
                participants: [], // ← fill properly!
                messages: [message],
                updatedAt: message.createdAt,
                isRead: true, isPinned: false,//
                profileImageLink: nil
            )
            conversations.append(newConv)
        }
    }
    
    func sendText(_ text: String, to conversation: Conversation) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let now = Date()
        let selfMessage = Message(
            text: text,
            createdAt: now,
            author: sampleLoggedInUser
        )
        
        // 1. Optimistic UI update
        appendMessage(selfMessage, to: conversation.id)
        
        // 2. Send in background
        Task.detached(priority: .userInitiated) {
            if conversation.isGroupChat { // you need to decide how to detect it
                await self.groupManager?.send(text, in: conversation)
            } else {
                await self.peerManager?.send(text, to: conversation)
            }
        }
    }
}
