import Amplify
import AWSCognitoAuthPlugin
import SwiftUI
import IQKeyboardManagerSwift
import AWSCore
import Stripe
import AWSS3StoragePlugin
import AWSAPIPlugin


@main
struct BiteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = false
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
           identityPoolId:"us-east-1:08c1e23b-0501-4cbd-b17e-078739ff5c2f")

        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        StripeAPI.defaultPublishableKey = "pk_test_51II5QzLiID1kXMzT5KqwEHtO05jUyyjBSOUItaBdD3DLCPPFccqXRS9jSSOShKntz42QyUpuROfJqjpNZY4JdLwz00eElzmKW9"

        return true
    }
}

struct BiteApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
