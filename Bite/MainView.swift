//
//  MainView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI

struct MainView: View {
    @State var selection : Int = 1
    
    
    var body: some View {
        NavigationView{
            //MARK:- Implement UIKit TabBar
            UIKitTabView{
                GiftingView().tab(title: "", image: "giftIcon", selectedImage: "giftIconSelect", badgeValue: "")
                    
                HomeView().tab(title: "", image: "homeIcon", selectedImage: "homeIconSelect", badgeValue: "")
                
                WalletView().tab(title: "", image: "Wallet Icon", selectedImage: "walletIconSelect", badgeValue: "")
                
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        //MARK:- swiftui TabBar implementation
        //        NavigationView{
        //            TabView(selection: $selection) {
        //                GiftingView()
        //                    .tabItem {
        //                        Label("", image: "giftIcon")
        //                    }
        //                    .tag(0)
        //
        //                HomeView()
        //                    .tabItem {
        //                        Label("", image: "homeIcon")
        //                    }
        //                    .tag(1)
        //
        //                WalletView()
        //                    .tabItem {
        //                        Label("", image: "Wallet Icon")
        //                    }
        //                    .tag(2)
        //            }
        //            .onAppear(){
        //                UITabBar.appearance().barTintColor = .white
        //                UITabBar.appearance().isTranslucent = true
        //            }
        //            .navigationBarHidden(true)
        //            .navigationBarBackButtonHidden(true)
        //        }
        //        .navigationBarHidden(true)
        //        .navigationBarBackButtonHidden(true)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(selection: 1)
    }
}
