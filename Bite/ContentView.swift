import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = false

    var body: some View {
//        if isLoggedIn {
//            HomeView()
//
//        } else {
//            LogInView()
//
//        }
//        HomeView()
        HomeView()
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
