import Foundation
import Combine
import SwiftUI

enum UserThemePreference: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

/// Global state to manage the ERP App
class ERPState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: UserProfile? = nil
    
    // Theme
    @Published var selectedTheme: UserThemePreference = .system
    
    // View Filters
    @Published var documentFilter: String = "All"
    
    // Navigation State
    @Published var selectedInbox: InboxFolder? = nil
    
    // Multi-Selection State
    @Published var selectedDocuments: Set<Document.ID> = []
    
    // Column Filters
    @Published var typeFilter: String = ""
    @Published var initiatorFilter: String = ""
    @Published var addressedToFilter: String = ""
    @Published var stageFilter: String = ""
    @Published var numberFilter: String = ""
    @Published var correspondentFilter: String = ""
    @Published var summaryFilter: String = ""
    @Published var outNumberFilter: String = ""
    
    // Tabs
    @Published var openDocuments: [Document] = []
    
    // Mock Data loading
    func loadMockData() {
        self.currentUser = UserProfile.mock
        self.isLoggedIn = true
    }
    
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
        self.selectedInbox = nil
        self.selectedDocuments.removeAll()
        self.openDocuments.removeAll()
    }
}
