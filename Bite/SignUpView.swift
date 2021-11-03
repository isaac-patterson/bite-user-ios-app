import SwiftUI

final class SignUpViewModel: ObservableObject {
    func logIn() {
        DispatchQueue.main.async {
            precondition(Thread.isMainThread)
        }
    }
}

struct SignUpView: View {
    @Environment(\.presentationMode) var presentation

    @StateObject var viewModel = SignUpViewModel()
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isPresentingConfirmationCode: Bool = false
    
    var body: some View {
        VStack (){
            List {
                Group {
                    TextField("Email", text: $username)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                    
                    SecureField("Confirm password", text: $confirmPassword)
                }
                .listRowBackground(Color(UIColor.systemGray3))
                
            }
            .listStyle(InsetGroupedListStyle())
            .frame(height: 150)
            
            Button("Sign up") {
                isPresentingConfirmationCode.toggle()
            }
           // .buttonStyle(.bordered)
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Sign Up").font(.headline)
            }
        }
        .sheet(
            isPresented: $isPresentingConfirmationCode,
            onDismiss: { presentation.wrappedValue.dismiss() }
        ) {
            ConfirmationCodeSheet()
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
