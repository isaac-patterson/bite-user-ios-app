//
//  NameSignupView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 09/09/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct SignupLastNameView: View {
    @State var lastName = ""
    @State var isShowbirthDateView = false
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
                
                Text("What's your last name?")
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 100)
                                
                FloatingLabelTextField($lastName, placeholder: "Last name") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)

                
                Spacer().frame(height: 154)
                
                NavigationLink(
                    destination: BirthdayInputView(),
                    isActive: $isShowbirthDateView)
                {
                    
                }
                
                Button(action: {
                    if lastName == ""{
                        alertViewMsg = "Please enter last name"
                        isShowAlertView.toggle()
                    }else{
                        signupData.data.lastName = lastName
                        isShowbirthDateView.toggle()
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

struct SignupLastNameView_Previews: PreviewProvider {
    static var previews: some View {
        SignupLastNameView()
    }
}
