//
//  EditCardView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 16/07/21.
//

import SwiftUI

struct EditCardView: View {
    
    @State var cardNoText = "**** **** **** 1234"
    @State var expiryDateText = "06/19"
    @State var cvvText = "123"
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    CustomNavigationView()
                    Spacer().frame(height:0)
                    Divider()
                    Spacer().frame(height:12)
                }
                Group{
                HStack() {
                    Spacer().frame(width:10)
                    Text("edit card")
                        .font(.custom("Quicksand-Medium", fixedSize: 25))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                Spacer().frame(height:25)
                HStack() {
                    Spacer().frame(width:15)
                Text("card number")
                    .font(.custom("Quicksand-Medium", fixedSize: 12))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                }
                HStack{
                    Spacer().frame(width:20)
                    Image("visaCardIcon")
                    Spacer().frame(width:15)
                    TextField("**** **** **** 1234", text: $cardNoText)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .font(.custom("SourceSansPro-Regular", size: 18))
                        .frame(height:25)
                        .background(Color.init(.sRGB, red: 196/255, green: 196/255, blue: 196/255, opacity: 0.39))
                    Spacer().frame(width:20)
                }
                Spacer().frame(height:45)
                HStack{
                    Spacer().frame(width: 25)
                    VStack(alignment:.leading){
                        Text("exp. date")
                            .font(.custom("Quicksand-Medium", fixedSize: 14))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        TextField("01/21", text: $expiryDateText)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .font(.custom("SourceSansPro-Regular", size: 12))
                            .frame(height:25)
                            .background(Color.init(.sRGB, red: 196/255, green: 196/255, blue: 196/255, opacity: 0.39))
                    }
                    Spacer().frame(width: 40)
                    VStack(alignment:.leading){
                        Text("cvv")
                            .font(.custom("Quicksand-Medium", fixedSize: 14))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        TextField("01/21", text: $expiryDateText)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .font(.custom("SourceSansPro-Regular", size: 12))
                            .frame(height:25)
                            .background(Color.init(.sRGB, red: 196/255, green: 196/255, blue: 196/255, opacity: 0.39))
                    }
                    Spacer().frame(width: 65)

                }

            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
}

struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView()
    }
}
