//
//  EditPasswordView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 16/07/21.
//

import SwiftUI
import Amplify
import AWSPluginsCore

struct EditPasswordView: View {
    @State var currentPasswordText = ""
    @State var newPasswordText = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Spacer().frame(width:18)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }, label: {
                        Image("CloseIcon")
                    })
                    Spacer()
                }
                Spacer().frame(height:143)
                HStack{
                    Spacer().frame(width:18)
                    VStack(alignment: .leading){
                        Text("Current Password")
                            .foregroundColor(Color.init(hex: "9999A1"))
                            .font(.custom("Quicksand-Medium", size: 16))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        TextField("Current Password", text: $currentPasswordText)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .font(.custom("Quicksand-Regular", size: 25))
                            .frame(height:45)
                            .background(Color.init(.sRGB, red: 242/255, green: 134/255, blue: 39/255, opacity: 0.65))
                        
                    }
                    Spacer().frame(width:18)
                }
                Spacer().frame(height:57)
                HStack{
                    Spacer().frame(width:18)
                    VStack(alignment: .leading){
                        Text("New Password")
                            .foregroundColor(Color.init(hex: "9999A1"))
                            .font(.custom("Quicksand-Medium", size: 16))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        TextField("New Password", text: $newPasswordText)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .font(.custom("Quicksand-Regular", size: 25))
                            .frame(height:45)
                            .background(Color.init(.sRGB, red: 242/255, green: 134/255, blue: 39/255, opacity: 0.65))
                        
                    }
                    Spacer().frame(width:18)
                }
                Spacer().frame(height:300)
                Button(action: {
                    if currentPasswordText == ""{
                        alertViewMsg = "Please Current password"
                        isShowAlertView.toggle()
                    }else if newPasswordText == ""{
                        alertViewMsg = "Please enter new password"
                        isShowAlertView.toggle()
                    }else{
                        changePassword(oldPassword: currentPasswordText, newPassword: newPasswordText)
                    }
                }, label: {
                    Text("Update Password")
                        .foregroundColor(.black)
                        .font(.custom("Quicksand-Bold", size: 20))
                        .frame(width: UIScreen.main.bounds.width-36, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                })
                .frame(width: UIScreen.main.bounds.width-36, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.init(.sRGB, red: 242/255, green: 134/255, blue: 39/255, opacity: 0.65))
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)

            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        }
    }
    
    //MARK:- update password in Amplify
    func changePassword(oldPassword: String, newPassword: String) {
        Amplify.Auth.update(oldPassword: oldPassword, to: newPassword) { result in
            switch result {
            case .success:
                alertViewMsg = "Change password succeeded"
                isShowAlertView.toggle()
                print("Change password succeeded")
            case .failure(let error):
                alertViewMsg = error.errorDescription
                isShowAlertView.toggle()
                print("Change password failed with error \(error)")
            }
        }
    }
}

struct EditPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        EditPasswordView()
    }
}
