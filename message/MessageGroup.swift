// MessageGroup.swift

import Foundation

actor MessageGroup {
    weak var service: MessageService?

    private var socket: CFSocket?
    private var isRunning = false

    init(service: MessageService) {
        self.service = service
    }

    func startListening() {
        guard !isRunning else { return }
        isRunning = true
        Task.detached { await self.runMulticastLoop() }
    }

    func runMulticastLoop() async {

    }
    
    func send(_ text: String, in conversation: Conversation) {

    }
    
    deinit {
    }
}
