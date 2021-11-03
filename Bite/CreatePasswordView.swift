//
//  CreatePasswordView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI
import Amplify

struct CreatePasswordView: View {
    
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var username = ""
    @State var isShowOtpView = false
    @ObservedObject var signupData = SignupModel.shared
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""
    @State var loading = false
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Group{
                    BackButtonBarView()
                }
                Spacer().frame(height: 20)
                
                Text("What's your \n password?")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 100)
                
                FloatingLabelTextField($password, placeholder: "Password") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)
                
                Spacer().frame(height: 50)
                
                FloatingLabelTextField($confirmPassword, placeholder: "Confirm Password") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)
                
                Spacer().frame(height: 109)
                
                Button(action: {
                    if password == ""{
                        alertViewMsg = "Please enter password"
                        isShowAlertView.toggle()
                    }else if confirmPassword == ""{
                        alertViewMsg = "Please enter confirm password"
                        isShowAlertView.toggle()
                    }else if password != confirmPassword{
                        alertViewMsg = "Passwords do not match"
                        isShowAlertView.toggle()
                    }else{
                        signupData.data.password = password
                        loading.toggle()
                        signUp()
                        
                    }
                }, label: {
                    if loading {
                        CircleLoader()
                            .frame(width: (UIScreen.main.bounds.size.width-108), height: 55,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                    }else{
                        Text("Next")
                            .font(.custom("Quicksand-Bold", size: 24))
                            .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(30)
                .foregroundColor(.white)
                
                NavigationLink(
                    destination: OtpView(),
                    isActive: $isShowOtpView)
                {
                    
                }
                
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)
                
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
    }
    
    //MARK:- create user in amplify
    func signUp() {
        
        loading.toggle()
        let no = "+64" + signupData.data.mobileNumber
        let fullName = signupData.data.firstName + " " + signupData.data.lastName
        let userAttributes = [AuthUserAttribute(.email, value: signupData.data.email), AuthUserAttribute(.name, value: fullName), AuthUserAttribute(.preferredUsername, value: signupData.data.username), AuthUserAttribute(.custom("school_email"), value: signupData.data.schoolEmail), AuthUserAttribute(.custom("username"), value: signupData.data.username), AuthUserAttribute(.custom("last_name"), value: signupData.data.lastName),AuthUserAttribute(.custom("birthDate"), value: signupData.data.bithDate), AuthUserAttribute(.custom("first_name"), value: signupData.data.firstName)]
        
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        Amplify.Auth.signUp(username: signupData.data.email, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                loading.toggle()
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {                    print("Delivery details \(String(describing: deliveryDetails))")
                    isShowOtpView.toggle()
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                loading.toggle()
                alertViewMsg = error.errorDescription
                isShowAlertView.toggle()
                print("An error occurred while registering a user \(error)")
            }
        }
        loading.toggle()
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
    }
}
