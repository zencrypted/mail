import SwiftUI
internal import UniformTypeIdentifiers

struct LoginView: View {
    @EnvironmentObject var state: ERPState
    
    @State private var selectedFileURL: URL?
    @State private var password = ""
    @State private var isFileImporterPresented = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(ERPTheme.primaryText)
            
            Text("ERP Secure Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .erpTextStyle()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Private Key File")
                    .font(.headline)
                    .erpTextStyle()
                
                HStack {
                    Text(selectedFileURL?.lastPathComponent ?? "No file selected")
                        .foregroundColor(selectedFileURL == nil ? ERPTheme.secondaryText : ERPTheme.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(ERPTheme.secondaryBackground.opacity(0.3))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ERPTheme.border, lineWidth: 1)
                        )
                    
                    Button("Select File") {
                        isFileImporterPresented = true
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(ERPTheme.invertedBackground)
                    .foregroundColor(ERPTheme.invertedText)
                    .cornerRadius(8)
                    .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: 400)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Password")
                    .font(.headline)
                    .erpTextStyle()
                
                SecureField("Enter password", text: $password)
                    .padding()
                    .background(ERPTheme.secondaryBackground.opacity(0.3))
                    .cornerRadius(8)
                    .foregroundColor(ERPTheme.primaryText)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ERPTheme.border, lineWidth: 1)
                    )
            }
            .frame(maxWidth: 400)
            
            if showingError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Read & Login") {
                handleLogin()
            }
            .disabled(selectedFileURL == nil || password.isEmpty)
            .frame(maxWidth: 400)
            .padding()
            .background((selectedFileURL == nil || password.isEmpty) ? ERPTheme.secondaryBackground : ERPTheme.invertedBackground)
            .foregroundColor((selectedFileURL == nil || password.isEmpty) ? ERPTheme.secondaryText : ERPTheme.invertedText)
            .cornerRadius(8)
            .font(.title3.bold())
            .padding(.top, 10)
            
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .erpBackground()
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.data, .plainText]) { result in
            switch result {
            case .success(let url):
                selectedFileURL = url
            case .failure(let error):
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
    
    private func handleLogin() {
        // Mock authentication
        if password == "123" {
            state.loadMockData()
        } else {
            errorMessage = "Invalid password. Use '123' for testing."
            showingError = true
        }
    }
}

#Preview {
    LoginView().environmentObject(ERPState())
}
