//
//  UsernameView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct UsernameView: View {
    
    @State var username = ""
    @State var isShowNameView = false
    @ObservedObject var signupData = SignupModel.shared
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""


    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Group{
                BackButtonBarView()
                }
                Spacer().frame(height: 20)
                
                Text("What's your \n username?")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 175)
                                
                FloatingLabelTextField($username, placeholder: "username") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)

                Spacer().frame(height: 154)
                
                NavigationLink(
                    destination: CreatePasswordView(),
                    isActive: $isShowNameView)
                {
                    
                }
                
                Button(action: {
                    if username == ""{
                        alertViewMsg = "Please enter username"
                        isShowAlertView.toggle()
                    }else{
                        signupData.data.username = username
                        isShowNameView.toggle()
                    }
                }, label: {
                    Text("Next")
                        .font(.custom("Quicksand-Bold", size: 24))
                        .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(30)
                .foregroundColor(.white)
                
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)

            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)


    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
