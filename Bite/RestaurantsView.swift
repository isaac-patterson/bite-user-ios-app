//
//  RestaurantsView.swift
//  Bite
//
//  Created by Isaac Patterson on 30/06/21.
//

import SwiftUI

struct RestaurantsView: View {
    
    // this list will be populated by an api call
    @State var restaurants: [Restaurant] = []

    var body: some View {
        NavigationView {
            
            //TODO
            
            //Make some dummy data for the restaurants variable
            //Create a page called MenuView     
            //On button click redirect to the new menuview, passing through the
            
            List(restaurants) { restaurant in
                Button(restaurant.name) {
                    precondition(Thread.isMainThread)
                }
            }
            .navigationTitle("Restaurants")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(uiColor: UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView()
    }
}
