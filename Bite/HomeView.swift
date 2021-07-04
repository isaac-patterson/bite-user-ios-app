import SwiftUI

struct HomeView: View {
    var body: some View {
            TabView {
                NavigationView {
                    RestaurantsView()
                }
                .tabItem {
                    Label("Shop", systemImage: "arrow.up.doc")
                }
                NavigationView {
                    Text("Purchases")
                        .navigationTitle("Purchases")
                }
                .tabItem {
                    Label("Cart", systemImage: "arrow.down.doc")
                }
                NavigationView {
                    Text("Contacts")
                        .navigationTitle("Contacts")
                }
                .tabItem {
                    Label("Profile", systemImage: "person.text.rectangle")
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
