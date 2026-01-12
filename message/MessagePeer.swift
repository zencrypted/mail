// MessagePeer.swift

// MessagePeer implements Multicast Topic 28 Reader/Writer for Peer-to-Peer communications

import Foundation

actor MessagePeer {
    var topic: Int = 28
    weak var service: MessageService?
    private var socket: CFSocket?
    private let myIdentifier: String
    
    init(service: MessageService) {
        self.service = service
        self.myIdentifier = Self.deviceUniqueIdentifier()
    }
    
    func startListening() { Task { await self.runListeningLoop() } }
    
    private func runListeningLoop() async {
    }
    
    func send(_ text: String, to conversation: Conversation) {
    }
    
    static func deviceUniqueIdentifier() -> String {
            #if os(macOS)
            // macOS path
            let vendorPart = ""  // no real equivalent on macOS → usually empty or use some other stable value
            let name = Host.current().localizedName ?? "Mac"
            
            #else
            // iOS / iPadOS / tvOS / watchOS / visionOS path
            let vendor = UIDevice.current.identifierForVendor?.uuidString ?? ""
            let name = Host.current().localizedName ?? "Device"
            
            #endif
            
            if vendorPart.isEmpty {
                return name
            } else {
                return "\(vendorPart)-\(name)"
            }
        }
}
