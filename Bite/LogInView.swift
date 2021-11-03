import SwiftUI

final class LogInViewModel: ObservableObject {
    func logIn() {
        DispatchQueue.main.async {
            precondition(Thread.isMainThread)
            
        }
    }
}

struct LogInView: View {
    init () {
        UITableView.appearance().backgroundColor = .clear
    }
    @Environment(\.presentationMode) var presentation

    @StateObject var viewModel = LogInViewModel()
    @State var username: String = ""
    @State var password: String = ""
    @State var showHomeView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Group {
                        TextField("Email", text: $username)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text: $password)
                        
                    }
                    .listRowBackground(Color(UIColor.systemGray3))

                }
                .listStyle(InsetGroupedListStyle())
                .frame(height: 100)
                
                
                Button("Log in") {
                    showHomeView.toggle()
                    viewModel.logIn()
                }
                //.buttonStyle(.bordered)
                NavigationLink(destination: HomeView(), isActive: $showHomeView) {
                    EmptyView()
                }
                
                HStack {
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Forgot Password")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }.colorMultiply(Color(UIColor.systemGray3))
    }
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
