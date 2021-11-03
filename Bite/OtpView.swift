//
//  OtpView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 09/07/21.
//

import SwiftUI
import Amplify

struct OtpView: View {
    
    @State var isShowLoginView: Bool = false
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""
    @State var otpString = ""
    @State var isShowLoginAlert = false
    @State var minutes: Int = 01
    @State var seconds: Int = 59
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    @State var loading = false
    var comeForConfirmUser = false
    var emailId = ""
    @State var isShowHomeView = false
    @ObservedObject var signupData = SignupModel.shared
    
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 0){
                Group{
                BackButtonBarView()
                }
                Group{
                Spacer().frame(height: 55)
                
                Text("Insert 6 digit code")
                    .font(.custom("Quicksand-Bold", fixedSize: 27))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 122)
                
                PasscodeField(maxDigits: 6, label: "", pin: otpString, showPin: true) { pin, isPin in
                    print(pin)
                    otpString = pin
                }
                }
                Spacer().frame(height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
//                HStack{
//                    Spacer().frame(width:25)
//                    Button(action: {
//                        resendOtp()
//                    }, label: {
//                    Text("Resend otp")
//                })
//                .disabled(timerIsPaused)
//                Spacer()
//                    Text("\(minutes):\(seconds)")
//                    Spacer().frame(width:25)
//                }
                
                Spacer().frame(height: 170, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    if otpString == ""{
                        alertViewMsg = "Please enter otp"
                        isShowAlertView.toggle()
                        
                    }else{
                        loading.toggle()
                        if comeForConfirmUser {
                            confirmSignUp(for: emailId, with: otpString)
                        }else{
                        confirmSignUp(for: signupData.data.email, with: otpString)
                        }
                        
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
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)

                NavigationLink(
                    destination: SignInView(comeFrom: "otp"),
                    isActive: $isShowLoginView){
                    
                }
                
                NavigationLink(
                    destination: MainView(),
                    isActive: $isShowHomeView)
                {
                    
                }
                
                .alert(isPresented:$isShowLoginAlert) {
                    Alert(
                        title: Text(alertViewMsg),
                        message: Text(""),
                        dismissButton: .default(Text("OK"), action: {
                            isShowLoginView.toggle()
                        })
                    )
                }
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .padding(.top, 0)
            

        }
        .onAppear(perform: {
            startTimer()
            alertViewMsg = "Please enter otp sent to your email id."
            isShowAlertView.toggle()
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                loading = false
                print("Confirm signUp succeeded")
                if comeForConfirmUser {
                    alertViewMsg = "You have successfully verified your account. Please sign in with email and password."
                    isShowLoginAlert.toggle()
                }else{
                    alertViewMsg = "You have successfully created account. Please sign in with email and password."
                    isShowLoginAlert.toggle()
                }
            case .failure(let error):
                loading = false
                alertViewMsg = error.errorDescription
                isShowAlertView.toggle()
                print("An error occurred while confirming sign up \(error)")
            }
            loading = false
        }
        
        
    }
    
    func resendOtp()
    {
        Amplify.Auth.resendConfirmationCode(for: .email) { result in
               switch result {
               case .success(let deliveryDetails):
                   print("Resend code send to - \(deliveryDetails)")
               case .failure(let error):
                   print("Resend code failed with error \(error)")
               }
           }
    }
    
    func startTimer(){
        timerIsPaused = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
                self.minutes = 0
                self.seconds = self.seconds - 1
            if self.seconds == 0{
                stopTimer()
            }
        }
      }
      
      func stopTimer(){
        timerIsPaused = false
        timer?.invalidate()
        timer = nil
      }
}

struct OtpView_Previews: PreviewProvider {
    static var previews: some View {
        OtpView()
    }
}
