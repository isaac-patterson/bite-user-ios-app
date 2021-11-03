//
//  EnterMobileNoView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 08/07/21.
//

import SwiftUI

struct EnterMobileNoView: View {
    
    @State var mobileNo = ""
    @State var alertViewMsg = ""
    @State var isShowOtpView: Bool = false
    @State var isShowAlertView: Bool = false
    @State var isShowSigninView = false
    @ObservedObject var signupData = SignupModel.shared
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 0){
                Group{
                BackButtonBarView()
                Spacer().frame(height: 55)
                }
                Group{

                Text("What's Your Number?")
                    .font(.custom("Quicksand-Bold", fixedSize: 27))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 122)
                
                PasscodeField(maxDigits: 10, label: "", pin: mobileNo, showPin: true) { pin, isPin in
                    signupData.data.mobileNumber = pin
                    mobileNo = pin
                    print(pin)
                }
                
                Spacer().frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    isShowSigninView.toggle()
                }, label: {
                    Text("Sign in with email")
                        .underline()
                        .foregroundColor(Color.init("AppThemeTextColor"))
                })
                }
                NavigationLink(
                    destination: SignInView(comeFrom: "MobileNumber"),
                    isActive: $isShowSigninView)
                {
                    
                }
                
                Spacer().frame(height: 122, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    if mobileNo == ""{
                        isShowAlertView.toggle()
                        alertViewMsg = "Please enter mobile number"
                    }else if !isValidPhone(phone: mobileNo){
                        isShowAlertView.toggle()
                        alertViewMsg = "Please enter vaild mobile number"
                    }
                    else{
                        isShowOtpView.toggle()
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
                    destination: StudentConfirmationView(),
                    isActive: $isShowOtpView){
                    
                }
                
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)
                
            }
            .introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = true
            }
            .onAppear(perform: {
                let countryCode = NSLocale.current.regionCode
                print(countryCode ?? "")
            })
            .padding(.top, 0)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
    
}

struct EnterMobileNoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EnterMobileNoView()
        }
    }
}


public struct PasscodeField: View {
    
    var maxDigits: Int = 6
    var label = "Enter One Time Password"
    
    @State var pin: String = ""
    @State var showPin = true
    @State var image: UIImage?
    //@State var isDisabled = false
    
    
    var handler: (String, (Bool) -> Void) -> Void
    
    public var body: some View {
        VStack(spacing: 10){
            Text(label).font(.title)
            ZStack {
                pinDots
                backgroundField
            }
            showPinStack
        }
        
    }
    
    private var pinDots: some View {
        HStack(alignment: .center) {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(self.getImageName(at: index))
                    .font(.system(size: 45))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer()
            }.frame(minWidth: 0, maxWidth: 50)
            .padding(.trailing, -24)
            Spacer()
            
        }
        
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            
            // Introspect library can used to make the textField become first resonder on appearing
            // if you decide to add the pod 'Introspect' and import it, comment #50 to #53 and uncomment #55 to #61
            
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
        //.disabled(isDisabled)
        
        //             .introspectTextField { textField in
        //                 textField.tintColor = .clear
        //                 textField.textColor = .clear
        //                 textField.keyboardType = .numberPad
        //                 textField.becomeFirstResponder()
        //                 textField.isEnabled = !self.isDisabled
        //         }
    }
    
    private var showPinStack: some View {
        HStack {
            Spacer()
            if !pin.isEmpty {
                //showPinButton
            }
        }
        .frame(height: 0)
        .padding([.trailing])
    }
    
    private var showPinButton: some View {
        Button(action: {
            self.showPin.toggle()
        }, label: {
            self.showPin ?
                Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
                Image(systemName: "eye.fill").foregroundColor(.primary)
        })
    }
    
    private func submitPin() {
        //guard !pin.isEmpty else {
        //showPin = false
        //return
        //}
        
        if pin.count == maxDigits {
            //isDisabled = true
            
            handler(pin) { isSuccess in
                if isSuccess {
                    print("pin matched, go to next page, no action to perfrom here")
                } else {
                    pin = ""
                    //isDisabled = false
                    print("this has to called after showing toast why is the failure")
                }
            }
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "bottomLine"
        }
        
        if self.showPin {

            return self.pin.digits[index].numberString + ".bottomLine"
        }
        
        return "bottomLine"
    }
}


public struct BackButtonBarView: View
{
    @Environment(\.presentationMode) var mode

    public var body: some View
    {
        Spacer().frame(height:20)
        HStack(alignment: .center){
            
            Spacer().frame(width:25)
            
            VStack(alignment: .leading){
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Image("backIcon")
                })
                .frame(width: 35, height: 35, alignment: .leading)
            }
            Spacer()
            
        }
        
        Spacer().frame(height: 30)
    }
}
