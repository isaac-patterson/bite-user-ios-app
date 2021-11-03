import SwiftUI
import Amplify
import AWSPluginsCore

struct ContentView: View {
    

    var body: some View {
        
        ///check if session not expire show home screen, if exprie then show signup screen
        if getsession()
        {
            MainView(selection: 1)
            
        } else {
            WalkthroughView()
            
        }
    }
    
    func fetchCurrentAuthSession() -> Bool {
        var isLoggedIn = false
        
        let semaphore = DispatchSemaphore(value: 0)
        
        Amplify.Auth.fetchAuthSession { (result) in
            switch result {
            case .success(_):
                isLoggedIn = getsession()
                
            case .failure(let authError):
                print(authError)
            }
            semaphore.signal()
            
        }
        
        semaphore.wait()
        
        return isLoggedIn
    }
    
    //MARK:- get session from amplify
    func getsession() -> Bool
    {
        var isLoggedIn = false
        
        let semaphore = DispatchSemaphore(value: 0)

        Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()
                
                // Get cognito user pool token
                if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    print("Id token - \(tokens.idToken) ")
                    isLoggedIn = session.isSignedIn
                    LoginUserModel.shared.data.idToken = tokens.idToken
                    LoginUserModel.shared.data.accessToken = tokens.accessToken
                    LoginUserModel.shared.data.refreshToken = tokens.refreshToken

                }
                
            } catch {
                isLoggedIn = false
                print("Fetch auth session failed with error - \(error)")
            }
            semaphore.signal()

        }
        
        semaphore.wait()

        return isLoggedIn
    }
    
    func signOutLocally() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("Successfully signed out")

            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


