import SwiftUI

struct Participant: Identifiable, Equatable, Hashable {
    let id: String = UUID().uuidString
    let firstName: String
    let lastName: String
    let username: String
    let profileImageLink: URL?
    
    var name: PersonNameComponents {
        PersonNameComponents(
            givenName: self.firstName,
            familyName: self.lastName,
            nickname: self.username
        )
    }
}

let sampleParticipantJohn = Participant(
    firstName: "John",
    lastName: "Doe",
    username: "username_for_John",
    profileImageLink: URL(string: "https://this-person-does-not-exist.com/img/avatar-gen08619ad3edb628d04b45cea6a487c665.jpg")
)
let sampleParticipantJane = Participant(
    firstName: "Jane",
    lastName: "Doe",
    username: "username_for_Jane",
    profileImageLink: nil
)
let sampleParticipantAlex = Participant(
    firstName: "Alex",
    lastName: "Smith",
    username: "username_for_Alex",
    profileImageLink: nil
)
let sampleLoggedInUser = sampleParticipantJohn
let sampleMessageHelloWorldJohn = Message(text: "Hello World", createdAt: .now, author: sampleParticipantJohn)
let sampleMessageHelloWorldJane = Message(text: "Hello World", createdAt: .now, author: sampleParticipantJane)
let sampleConversation = Conversation(
    participants: [sampleParticipantJohn, sampleParticipantJane],
    messages: [sampleMessageHelloWorldJohn, sampleMessageHelloWorldJane],
    updatedAt: Date.now,
    isRead: true,
    isPinned: true,
    profileImageLink: nil
)
let sampleLongConversation = Conversation(
    participants: [sampleParticipantJohn, sampleParticipantJane],
    messages: sampleMessages,
    updatedAt: Date.now,
    isRead: true,
    isPinned: true,
    profileImageLink: nil
)
let sampleGroupConversation = Conversation(
    participants: [sampleParticipantJohn, sampleParticipantJane, sampleParticipantAlex],
    messages: sampleGroupMessage,
    updatedAt: Date.now,
    isRead: false,
    isPinned: true,
    profileImageLink: nil
)
let sampleMessages = [
    Message(text: "Hey Johnny, what's up?", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "Nothing much, how about you?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "I'm doing great, thanks for asking!", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "No problem, I'm doing great too!", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Do you have any plans for this weekend?", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "No, I'm just chilling at home. What about you?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "I don't have any plans either, just wondered what you were up to.", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "Have you seen the new movie?", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "No, I haven't. What's it about?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "It's a great movie! You should watch it.", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "I'll definitely check it out!", createdAt: .now, author: sampleParticipantJane),
    Message(text: "What time is it playing at the local theater?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "It's at 7:00 PM.", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "You want to meet up at the coffee shop, then go check it out", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Sure! I'll see you there!", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "Great! See you there!", createdAt: .now, author: sampleParticipantJane)
]
let sampleGroupMessage = [
    Message(text: "Hey, where do y'all want to eat at tonight?", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "I don't know, I'm just thinking about it.", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Me either, I'm otherwise occupied at the moment.", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "How about the coffee shop?", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "Sounds good to me!", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Sounds good to me too!", createdAt: .now, author: sampleParticipantAlex)
]

struct Conversation: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let participants: [Participant]
    let messages: [Message]
    let updatedAt: Date
    let isRead: Bool
    let isPinned: Bool
    let profileImageLink: String?
    
    func particpantsNotIncludingCurrentUser() -> [Participant] {
        return participants.filter { $0 != sampleLoggedInUser }
    }
}

struct Message: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let text: String
    let createdAt: Date
    let updatedAt = Date()
    let author: Participant
    let attachments: Attachment? = nil
    let reactions: [Reaction] = []
}

struct Attachment: Identifiable, Hashable {
    let id: String
    let width: Int
    let height: Int
    let url: String
    let fileName: String
    let size: Int
    let type: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Hashable {
    let small: Thumbnail
    let large: Thumbnail
    let full: Thumbnail
}

struct Thumbnail: Hashable {
    let width: Int
    let height: Int
    let url: String
}


struct Reaction: Identifiable, Hashable {
    let id: UUID
    let message: Message
    let author: Participant
}

extension Date {
    var daysSinceNow: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date.now).day ?? 0
    }
}
