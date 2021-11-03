//
//  RedeemGiftPopView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 13/07/21.
//

import SwiftUI

struct RedeemGiftPopView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView{
            VStack {
                CustomNavigationView()
                    .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(height: 0)
                
                Divider()
                
                Spacer().frame(height:70)
                
                Image("coffeeIcon")
                
                Text("Coffee from Cafe Strata")
                    .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                    .foregroundColor(Color.init(hex: "9999A1"))
                
                Spacer().frame(height:43)
                
                VStack(alignment: .leading){
                    Text("Happy birthday Bro!! Hope it’s a good one, here’s a coffee since I know how much you love Strata!\n\n\nFrom Andy")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                        .foregroundColor(Color.white)
                        .frame(width: 253, height: 114)
                    
                }
                .frame(width: UIScreen.main.bounds.width-80, height: 218)
                .background(Color.init(.sRGB, red: 39/255, green: 96/255, blue: 242/255, opacity: 0.94))
                .cornerRadius(20)
                
                Spacer().frame(height:114)
                
                HStack(){
                    Spacer().frame(width: 37)
                    Button(action: {
                    }, label: {
                        Text("Redeem")
                            .font(.custom("SourceSansPro-Bold", size: 15))
                            .frame(width: 120, height: 43, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    })
                    .background(Color.init("AppThemeMusturd"))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    
                    Spacer().frame(width: 79)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("later")
                            .font(.custom("SourceSansPro-Bold", size: 15))
                            .frame(width: 120, height: 43, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    })
                    .background(Color.init("AppThemeMusturd"))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    
                    Spacer().frame(width: 37)
                    
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 0)
        
    }
}

struct RedeemGiftPopView_Previews: PreviewProvider {
    static var previews: some View {
        RedeemGiftPopView()
    }
}
