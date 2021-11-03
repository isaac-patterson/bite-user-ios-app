//
//  ResetPasswordView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 06/08/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI
import Amplify

struct ResetPasswordView: View {
    
    @State var temporaryPassword = ""
    @State var newPassword = ""
    @State var confirmPassword = ""
    @State var isShowLoginView: Bool = false
    @ObservedObject var signupData = SignupModel.shared
    @State var isShowAlertView: Bool = false
    @State var isShowLoginAlertView: Bool = false
    @State var alertViewMsg = ""
    var email = ""

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Group{
                BackButtonBarView()
                }
                Group{
                Spacer().frame(height: 20)
                
                Text("Password reset")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 50)
                }
                Group{
                FloatingLabelTextField($temporaryPassword, placeholder: "Verification Code") { (isChanged) in
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)
                
                Spacer().frame(height: 30)

                FloatingLabelTextField($newPassword, placeholder: "New password") { (isChanged) in
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)
               
                }
                Spacer().frame(height: 160)
                
                Button(action: {
                    confirmResetPassword()
                }, label: {
                    Text("Change")
                        .font(.custom("Quicksand-Bold", size: 24))
                        .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(30)
                .foregroundColor(.white)
                
                NavigationLink(
                    destination: SignInView(),
                    isActive: $isShowLoginView){
                    EmptyView()
                }
                
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)
                .alert(isPresented:$isShowLoginAlertView) {
                    Alert(
                        title: Text("You have successfully Reset Password. Please sign in with email and password."),
                        message: Text(""),
                        dismissButton: .default(Text("OK"), action: {
                            isShowLoginView.toggle()
                        })
                    )
                }

            }
            .padding(.top)
            .onAppear(perform: {
                alertViewMsg = "Check your email for verification code."
                isShowAlertView.toggle()
            })
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
    
    func confirmResetPassword() {
        Amplify.Auth.confirmResetPassword(
            for: email,
            with: newPassword,
            confirmationCode: temporaryPassword
        ) { result in
            switch result {
            case .success:
                print("Password reset confirmed")
                isShowLoginAlertView.toggle()
            case .failure(let error):
                print("Reset password failed with error \(error)")
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
