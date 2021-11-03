//
//  UserAgrementView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 11/08/21.
//

import SwiftUI

struct UserAgrementView: View {
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    NavigationBarView()
                    Spacer().frame(height:20)
                }
                Text("bite Application user Agrement")
                    .bold()
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer().frame(height: 30)
                
                Text("Protection from abusive users: You have the right to suspend or delete the accounts of abusive users who violate your app’s terms and conditions. Prohibited activities could include copyright infringement, spamming other users, and general misuse of your app. \n \nArbitration over litigation: You can choose to settle disputes via arbitration, which can be more efficient and cost-effective than litigation. \n \nLimited liability: This will vary from case to case, but including disclaimers in your terms and conditions can help limit your liabilities if disputes arise. \n \nUser benefits: Your terms and conditions agreement should explain the finer points of your app to the user, like how payment processing works, what kind of behavior is expected of users, and how to contact customer support. It should also tell them what rights they have as a user.")
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct UserAgrementView_Previews: PreviewProvider {
    static var previews: some View {
        UserAgrementView()
    }
}
