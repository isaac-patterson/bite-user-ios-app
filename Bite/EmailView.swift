//
//  EmailView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct EmailView: View {
    
    @State var email = ""
    @State var isShowUserNameView: Bool = false
    @ObservedObject var signupData = SignupModel.shared
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""


    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Group{
                BackButtonBarView()
                }
                Spacer().frame(height: 30)
                Group{
                Text("What's your email?")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 10)
                
                Text("For receipts")
                    .font(.custom("Quicksand-Bold", fixedSize: 18))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 175)
                }
                FloatingLabelTextField($email, placeholder: "Email") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)
                
                Spacer().frame(height: 154)
                
                Button(action: {
                    if email == ""{
                        isShowAlertView.toggle()
                        alertViewMsg = "Please Enter email"
                    }else if !isValidEmail(email: email){
                        isShowAlertView.toggle()
                        alertViewMsg = "Please Enter Vaild email"
                    }else{
                        signupData.data.email = email
                        isShowUserNameView.toggle()
                    }
                }, label: {
                    Text("Next")
                        .font(.custom("Quicksand-Bold", size: 24))
                        .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(30)
                .foregroundColor(.white)
                
                NavigationLink(
                    destination: UsernameView(),
                    isActive: $isShowUserNameView){
                    EmptyView()
                }
                
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)

            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)


    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView()
    }
}
