//
//  SendGiftPopupView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 13/07/21.
//

import SwiftUI

struct SendGiftPopupView: View {
    
    @State var text = ""
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ScrollView{
            VStack {
                                
                Spacer().frame(height:28)
                
                Image("coffeeIcon")
                
                Text("Coffee from Cafe Strata")
                    .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                    .foregroundColor(Color.init(hex: "9999A1"))
                    
                Spacer().frame(height:40)
                
                Text("Say something nice💙 ")
                    .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                    .foregroundColor(Color.black)
                
                Spacer().frame(height: 66)
                
                VStack(alignment: .leading){
                    TextEditor(text: $text)
                        .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                        .foregroundColor(.white)
                        .padding(.init(top: 50, leading: 45, bottom: 50, trailing: 45))
                }
                .frame(width: UIScreen.main.bounds.width-80, height: 277)
                .background(Color.init(.sRGB, red: 39/255, green: 96/255, blue: 242/255, opacity: 0.94))
                .cornerRadius(20)
                
                Spacer().frame(height:117)

                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Send")
                        .font(.custom("SourceSansPro-Bold", size: 15))
                        .frame(width: 120, height: 43, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(20)
                .foregroundColor(.white)
                
            }
        }
    }
}

struct SendGiftPopupView_Previews: PreviewProvider {
    static var previews: some View {
        SendGiftPopupView()
    }
}
