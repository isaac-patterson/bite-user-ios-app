//
//  WalkthroughView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 08/07/21.
//

import SwiftUI
import Introspect

struct logoImage: View {
    var body: some View{
        Image("newLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

    }
}

struct WalkthroughView: View {
    
    @State var showEnterMobileNoView: Bool = false
    @State var showSigninView  = false

    
    var body: some View {
        NavigationView{
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                Image("newLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(height:10)

                Text("bite")
                    .foregroundColor(Color.appThemeMustured)
                    .font(.custom("Poppins-ExtraBold", size: 80))
                
                Spacer().frame(height:145)
                Button(action: {
                    showSigninView.toggle()
                }) {
                    Text("Start").font(.custom("Quicksand-Bold", size: 22))
                        .frame(width: UIScreen.main.bounds.size.width-108, height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                }
                .background(Color.init("AppThemeMusturd"))
                .foregroundColor(.white)
                .cornerRadius(30)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)

                NavigationLink(
                    destination: SignInView(),
                    isActive: $showSigninView){
                    
                }
                
            }
            .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = true
            }

        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
}

struct WalkthroughView_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughView()
    }
}
