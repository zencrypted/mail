import SwiftUI

/// Main container for the CRM system, loaded after successful login.
struct MainTabView: View {
    @EnvironmentObject var state: CRMState
    
    var body: some View {
        TabView(selection: $state.selectedTab) {
            CRMMainView()
                .tabItem {
                    Label("CRM Messages", systemImage: "tray.full")
                }
                .tag(0)
            
            FormsView()
                .tabItem {
                    Label("Forms", systemImage: "list.clipboard")
                }
                .tag(1)
        }
        .accentColor(CRMTheme.accent)
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
                    .pickerStyle(.segmented)
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
                .padding()
                .frame(width: 245, height: 25)
            }
            
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    Picker("Theme", selection: $state.selectedTheme) {
                        ForEach(UserThemePreference.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 180)
                    
                    Picker("Language", selection: $state.selectedLanguage) {
                        ForEach(LanguagePreference.allCases) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 120)
                }
                .padding()
            }
        }
    }
}
