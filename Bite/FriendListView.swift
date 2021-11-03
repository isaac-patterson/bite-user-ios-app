//
//  FriendListView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 15/07/21.
//

import SwiftUI

struct FriendListView: View {
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView{
            VStack{
                CustomNavigationView()
                Spacer().frame(height:28)
                Image("coffeeIcon")
                Text(" Send a  Coffee from Cafe Strata to...")
                    .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                    .foregroundColor(Color.init(hex: "9999A1"))
                Spacer().frame(height:23)
                SearchBarView(text: $searchText)
                Divider()
                List{
                    ForEach(0..<6){index in
                        HStack(){
                            Spacer()
                            Text("Hugo Smith")
                                .multilineTextAlignment(.center)
                                .font(.custom("SourceSansPro-Bold", size: 14))
                            Spacer()
                            
                        }
                        .frame(height:76)
                    }
                    
                }
                .listStyle(PlainListStyle())
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Write Note")
                        .foregroundColor(.white)
                        .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                })
                .frame(width: UIScreen.main.bounds.width-250, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(30)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
