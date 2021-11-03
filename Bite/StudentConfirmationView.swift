//
//  SwiftUIView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 09/07/21.
//

import SwiftUI

struct StudentConfirmationView: View {
    
    @State var isShowSchoolEmailView: Bool = false
    @State var isShowEmailView: Bool = false
    
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .center, spacing: 0) {
                Group{
                BackButtonBarView()
                }

                Spacer().frame(height: 60)
                
                Text("Are you a student?")
                    .font(.custom("Quicksand-Bold", fixedSize: 28))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 20)
                
                Text("For student discounts 😎")
                    .font(.custom("Quicksand-Bold", fixedSize: 18))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer().frame(height: 148)
                
                HStack {
                    Spacer().frame(width:40)
                    Button(action: {
                        isShowSchoolEmailView.toggle()
                    }, label: {
                        Text("Yes")
                            .font(.custom("Quicksand-Bold", size: 24))
                            .frame(width: (UIScreen.main.bounds.size.width/2 - 58), height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    })
                    .background(Color.init("AppThemeMusturd"))
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowEmailView.toggle()
                    }, label: {
                        Text("No")
                            .font(.custom("Quicksand-Bold", size: 24))
                            .frame(width: (UIScreen.main.bounds.size.width/2 - 58), height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                    })
                    .background(Color.init("AppThemeMusturd"))
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    
                    Spacer().frame(width:40)
                    
                    NavigationLink(
                        destination: SchoolEmailView(),
                        isActive: $isShowSchoolEmailView){
                        
                    }
                    
                    NavigationLink(
                        destination: EmailView(),
                        isActive: $isShowEmailView){
                        
                    }
                    
                }
                
                .padding(.top, 0)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

        
    }
}

struct StudentConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        StudentConfirmationView()
    }
}
