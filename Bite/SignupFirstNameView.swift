//
//  SignupFirstNameView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 20/09/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct SignupFirstNameView: View {
    @State var firstName = ""
    @State var isShowlastNameView = false
    @ObservedObject var signupData = SignupModel.shared
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""
    @State var isShowSigninView = false

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Group{
                BackButtonBarView()
                Spacer().frame(height: 20)
                
                Text("What's your First name?")
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 100)
                }
                FloatingLabelTextField($firstName, placeholder: "First name") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)

                Spacer().frame(height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    isShowSigninView.toggle()
                }, label: {
                    Text("Sign in with email")
                        .underline()
                        .foregroundColor(Color.init("AppThemeTextColor"))
                })
                
                NavigationLink(
                    destination: SignInView(comeFrom: "MobileNumber"),
                    isActive: $isShowSigninView)
                {
                    
                }
            
                Spacer().frame(height: 154)
                
                NavigationLink(
                    destination: SignupLastNameView(),
                    isActive: $isShowlastNameView)
                {
                    
                }
                
                Button(action: {
                    if firstName == ""{
                        alertViewMsg = "Please enter first name"
                        isShowAlertView.toggle()
                    }else{
                        signupData.data.firstName = firstName
                        isShowlastNameView.toggle()
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
struct SignupFirstNameView_Previews: PreviewProvider {
    static var previews: some View {
        SignupFirstNameView()
    }
}
