//
//  ForgetPasswordView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 06/08/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI
import Amplify

struct ForgetPasswordView: View {
    
    @State var email = ""
    @State var isShowResetPassView: Bool = false
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
                
                Text("Password reset")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 30)
                
                Text("type your email below to recover password")
                    .font(.custom("Quicksand-Bold", fixedSize: 15))
                    .foregroundColor(Color.init(.sRGBLinear, red: 0, green: 0, blue: 0, opacity: 0.5))
                
                Spacer().frame(height: 110)
                
                FloatingLabelTextField($email, placeholder: "Email") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)
                
                Spacer().frame(height: 232)
                
                Button(action: {
                    if email == ""{
                        isShowAlertView.toggle()
                        alertViewMsg = "Please Enter email"
                    }else if !isValidEmail(email: email){
                        isShowAlertView.toggle()
                        alertViewMsg = "Please Enter Vaild email"
                    }else{
                        resetPassword(username: email)
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
                    destination: ResetPasswordView(email: email),
                    isActive: $isShowResetPassView){
                    EmptyView()
                }
                
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)
                
            }
            
            .padding(.top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)


    }
    
    func resetPassword(username: String) {
        
        
        Amplify.Auth.resetPassword(for: username) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                    isShowResetPassView.toggle()
                case .done:
                    print("Reset completed")
                }
            } catch {
                print("Reset password failed with error \(error)")
            }
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}
