import SwiftUI

struct FormsView: View {
    var body: some View {
        VStack {
            Image(systemName: "list.clipboard")
                .font(.system(size: 60))
                .foregroundColor(ERPTheme.primaryText)
                .padding()
            Text("Forms Management")
                .font(.largeTitle)
                .erpTextStyle()
            
            Text("Standalone forms will appear here.")
                .foregroundColor(ERPTheme.secondaryText)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .erpBackground()
    }
}

#Preview {
    FormsView()
}
