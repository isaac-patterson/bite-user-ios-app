//
//  SignInView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI
import Amplify
import AWSPluginsCore

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    @State var isShowHomeView = false
    @State var isShowAlert = false
    @State var isShowForgetPassView = false
    @State var title = ""
    @State var message = ""
    @ObservedObject var loginData = LoginUserModel.shared
    @State var loading = false
    @State var isShowLoginAlert = false
    @State var isShowOtpView = false
    @State var isShowSignupView = false
    var comeFrom = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack{
                if comeFrom == "MobileNumber"{
                    Group{
                        BackButtonBarView()
                    }
                }
                Text("What's your email?")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 80)
                
                Group{
                    FloatingLabelTextField($email, placeholder: "Email") { (isChanged) in
                        
                    } commit: {
                        
                    }
                    .floatingStyle(ThemeTextFieldStyle())
                    .frame(width: UIScreen.main.bounds.width-100,height: 70)
                    
                    Spacer().frame(height: 40)
                    
                    FloatingLabelTextField($password, placeholder: "Password") { (isChanged) in
                        
                    } commit: {
                        
                    }
                    .isSecureTextEntry(true)
                    .floatingStyle(ThemeTextFieldStyle())
                    .frame(width: UIScreen.main.bounds.width-100,height: 70)
                }
                Group{
                    Spacer().frame(height: 22)
                    
                    Button(action: {
                        isShowForgetPassView.toggle()
                    }, label: {
                        Text("Forgot Password")
                            .underline()
                            .foregroundColor(Color.init("AppThemeTextColor"))
                    })
                    
                    Spacer().frame(height: 150)
                    
                    Button(action: {
                        signin()
                    }, label: {
                        if loading {
                            CircleLoader()
                                .frame(height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        }else{
                            Text("Sign In")
                                .font(.custom("Quicksand-Bold", size: 24))
                                .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                    })
                    .background(Color.init("AppThemeMusturd"))
                    .cornerRadius(30)
                    .foregroundColor(.white)
                }
                Spacer().frame(height: 30)
                
                Button(action: {
                    isShowSignupView.toggle()
                }, label: {
                    Text("Sign up")
                        .foregroundColor(Color.init("AppThemeMusturd"))
                        .font(.custom("Quicksand-Bold", size: 24))
                        .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(30)

                })
                .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.appThemeMustured, lineWidth: 2))

                .alert(isPresented: $isShowAlert, title: title, message: message)
                
                Group{
                    NavigationLink(
                        destination: MainView(),
                        isActive: $isShowHomeView)
                    {
                        
                    }
                    
                    NavigationLink(
                        destination: ForgetPasswordView(),
                        isActive: $isShowForgetPassView)
                    {
                        
                    }
                    
                    NavigationLink(
                        destination: SignupFirstNameView(),
                        isActive: $isShowSignupView)
                    {
                        
                    }
                    
                    NavigationLink(
                        destination: OtpView(comeForConfirmUser: true, emailId: email),
                        isActive: $isShowOtpView)
                    {
                        
                    }
                    .alert(isPresented:$isShowLoginAlert) {
                        Alert(
                            title: Text(message),
                            message: Text(""),
                            dismissButton: .default(Text("OK"), action: {
                                isShowOtpView.toggle()
                            })
                        )
                    }
                }
            }
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
            }
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
        
    }
    
    //MARK:- Sign In with amplify
    func signin() {
        
        if email == "" {
            message = "Please Enter username!"
            isShowAlert.toggle()
        }else if !isValidEmail(email: email){
            message = "Please Enter Vaild email"
            isShowAlert.toggle()
        }else if password == ""{
            message = "Please Enter Password!"
            isShowAlert.toggle()
        }else{
            loading = true
            
            Amplify.Auth.signIn(username: email, password: password) { result in
                do {
                    let signinResult = try result.get()
                    switch signinResult.nextStep {
                    case .confirmSignInWithSMSMFACode(let deliveryDetails, let info):
                        print("SMS code send to \(deliveryDetails.destination)")
                        print("Additional info \(String(describing: info))")
                        loading = false
                        
                    // Prompt the user to enter the SMSMFA code they received
                    // Then invoke `confirmSignIn` api with the code
                    
                    case .confirmSignInWithCustomChallenge(let info):
                        print("Custom challenge, additional info \(String(describing: info))")
                        loading = false
                        
                    // Prompt the user to enter custom challenge answer
                    // Then invoke `confirmSignIn` api with the answer
                    
                    case .confirmSignInWithNewPassword(let info):
                        print("New password additional info \(String(describing: info))")
                        loading = false
                        
                    // Prompt the user to enter a new password
                    // Then invoke `confirmSignIn` api with new password
                    
                    case .resetPassword(let info):
                        print("Reset password additional info \(String(describing: info))")
                        loading = false
                        message = "You need to reset your account password."
                        isShowAlert.toggle()
                    // User needs to reset their password.
                    // Invoke `resetPassword` api to start the reset password
                    // flow, and once reset password flow completes, invoke
                    // `signIn` api to trigger signin flow again.
                    
                    case .confirmSignUp(let info):
                        print("Confirm signup additional info \(String(describing: info))")
                        
                        message = "Your email address isn't verified."
                        isShowLoginAlert.toggle()
                        
                    // User was not confirmed during the signup process.
                    // Invoke `confirmSignUp` api to confirm the user if
                    // they have the confirmation code. If they do not have the
                    // confirmation code, invoke `resendSignUpCode` to send the
                    // code again.
                    // After the user is confirmed, invoke the `signIn` api again.
                    case .done:
                        
                        // Use has successfully signed in to the app
                        print("Signin complete")
                        loading = false
                        isShowHomeView.toggle()
                    }
                } catch {
                    loading = false
                    message = "\(error)"
                    isShowAlert.toggle()
                    print ("Sign in failed \(error)")
                }
            }
            
        }
        
        
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


struct ThemeTextFieldStyle: FloatingLabelTextFieldStyle {
    func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        content
            .enablePlaceholderOnFocus(true)
            .disabled(false)
            .spaceBetweenTitleText(50) // Sets the space between title and text.
            .textAlignment(.leading) // Sets the alignment for text.
            .lineHeight(1) // Sets the line height.
            .selectedLineHeight(1.5) // Sets the selected line height.
            .lineColor(Color.init(red: 229/255, green: 229/255, blue: 299/255)) // Sets the line color.
            .selectedLineColor(Color.init(red: 229/255, green: 229/255, blue: 299/255)) // Sets the selected line color.
            .titleColor(Color.init("AppThemeMusturd")) // Sets the title color.
            .selectedTitleColor(Color.init("AppThemeMusturd")) // Sets the selected title color.
            .titleFont(.custom("Quicksand-Bold", fixedSize: 18)) // Sets the title font.
            .textColor(Color.init("AppThemeMusturd")) // Sets the text color.
            .selectedTextColor(Color.init("AppThemeMusturd")) // Sets the selected text color.
            .textFont(.custom("Quicksand-Bold", fixedSize: 18)) // Sets the text font.
            .placeholderColor(Color.init("AppThemeMusturd")) // Sets the placeholder color.
            .placeholderFont(.custom("Quicksand-Bold", fixedSize: 18)) // Sets the placeholder font.
    }
}
