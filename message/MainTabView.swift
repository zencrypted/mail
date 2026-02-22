import SwiftUI

/// Main container for the ERP system, loaded after successful login.
struct MainTabView: View {
    @EnvironmentObject var state: ERPState
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ERPMainView()
                .tabItem {
                    Label("ERP Messages", systemImage: "tray.full")
                }
                .tag(0)
            
            FormsView()
                .tabItem {
                    Label("Forms", systemImage: "list.clipboard")
                }
                .tag(1)
        }
        .accentColor(ERPTheme.accent)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if let user = state.currentUser {
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text("\(user.name) - \(user.role)")
                            .font(.headline)
                        Text(user.organization)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(width: 250, height: 25)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Picker("Filter", selection: $state.documentFilter) {
                    Text("All").tag("All")
                    Text("Processed").tag("Processed")
                    Text("Not Processed").tag("Not Processed")
                }
                .pickerStyle(.segmented)
                .frame(width: 300)
            }
            
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 20) {
                    Button("Notifications") {
                        // Show notifications popover
                    }
                    
                    Picker("Theme", selection: $state.selectedTheme) {
                        ForEach(UserThemePreference.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 100)
                    
                    Button("Exit") {
                        state.logout()
                    }
                    .foregroundColor(.red)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
