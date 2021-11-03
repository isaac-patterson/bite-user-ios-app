//
//  SchoolEmailView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 09/07/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct SchoolEmailView: View {
    
    @State var email = ""
    @State var isShowEmailView: Bool = false
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
                Group{
                Text("What's your email?")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 10)
                
                Text("For receipts")
                    .font(.custom("Quicksand-Bold", fixedSize: 18))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 28)
                
                Text("Use your university email for \n student discounts")
                    .font(.custom("Quicksand-Bold", fixedSize: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .frame(height: 60)
                
                Spacer().frame(height: 100)
                }
                FloatingLabelTextField($email, placeholder: "School Email") { (isChanged) in
                    
                } commit: {
                    
                }
                .floatingStyle(ThemeTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width-100,height: 70)
                
                Spacer().frame(height: 154)
                
                Button(action: {
                    if email == ""{
                        isShowAlertView.toggle()
                        alertViewMsg = "Please Enter school email"
                    }else if !isValidEmail(email: email){
                        isShowAlertView.toggle()
                        alertViewMsg = "Please Enter Vaild school email"
                    }else{
                        signupData.data.schoolEmail = email
                        isShowEmailView.toggle()
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
            NavigationLink(
                destination: EmailView(),
                isActive: $isShowEmailView){
                EmptyView()
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
}

struct SchoolEmailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SchoolEmailView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
                .previewDisplayName("iPhone 12 Pro Max")
            
        }
    }
}
