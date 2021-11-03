//
//  EditLastNameView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 16/07/21.
//

import SwiftUI
import Amplify
import AWSAPIPlugin

struct EditLastNameView: View {
    
    @State var lastNameText = "Rong"
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
                        Text("Last Name")
                            .foregroundColor(Color.init(hex: "9999A1"))
                            .font(.custom("Quicksand-Medium", size: 16))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        TextField("Last Name", text: $lastNameText)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .font(.custom("Quicksand-Regular", size: 25))
                            .frame(height:45)
                            .background(Color.init(.sRGB, red: 242/255, green: 134/255, blue: 39/255, opacity: 0.65))
                        
                    }
                    Spacer().frame(width:18)
                }
                Spacer().frame(height:380)
                Button(action: {
                    if lastNameText == ""{
                        alertViewMsg = "Please enter last name"
                        isShowAlertView.toggle()
                    }else{
                        updateAttribute()
                    }
                }, label: {
                    Text("Update Last Name")
                        .foregroundColor(.black)
                        .font(.custom("Quicksand-Bold", size: 20))
                        .frame(width: UIScreen.main.bounds.width-36, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                })
                .background(Color.init(.sRGB, red: 242/255, green: 134/255, blue: 39/255, opacity: 0.65))
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
    }
    
    //MARK:- update last Name in Amplify
    func updateAttribute() {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.custom("last_name"), value: lastNameText)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    UserDataModel.shared.data.last_name = lastNameText
                    alertViewMsg = "last name update successfully"
                    isShowAlertView.toggle()
                    print("Update completed")
                }
            } catch {
                print("Update attribute failed with error \(error)")
            }
        }
        
        let fullName = UserDataModel.shared.data.first_name + " " + lastNameText
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.name, value: fullName)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    UserDataModel.shared.data.name = fullName
                    print("Update completed")
                }
            } catch {
                print("Update attribute failed with error \(error)")
            }
        }
    }
}

struct EditLastNameView_Previews: PreviewProvider {
    static var previews: some View {
        EditLastNameView()
    }
}
