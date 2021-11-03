//
//  ContactUsView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 11/08/21.
//

import SwiftUI

struct ContactUsView: View {
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    NavigationBarView()
                    Spacer().frame(height:20)
                }
                Text("bite Application Contact Us")
                    .bold()
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer().frame(height: 30)
                
                Text("You can contact us from our mention mail id:\n\ndummy@mail.com\n\nyou can also contact us from our phone number:\n\n+64123456789")
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}
