//
//  GiftingView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI

struct GiftingView: View {
    @State var searchText = ""
    @State var isShowSideMenu = false
    @State var isShowPopUpView = false
    @State var isShowAlertView = false
    var treatView: some View {
        Group {
            VStack{
                Text("TREAT \nSOMEONE  💌")
                    .font(.custom("SourceSansPro-Bold", fixedSize: 36))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width:UIScreen.main.bounds.width-100)
                
            }
            .background(Color.init(hex: "64AAF3"))
            .cornerRadius(20)
            .frame(width: UIScreen.main.bounds.width-100, height: 130)
            
            Spacer().frame(height: 44)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack{
                    Group{
                    CustomNavigationView(isHideBackButton: true)
                        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(height: 0)
                    
                    Divider()
                    
                    Spacer().frame(height:11)
                    
                    HStack{
                        Spacer().frame(width: 22)
                        
                        Image("image 2")
                        
                        Spacer().frame(width: 10)
                        
                        Text("Why don’t you try sending a gift to someone? 😉")
                            .font(.custom("SourceSansPro-Regular", fixedSize: 24))
                            .padding(.trailing, 34)
                    }
                    
                    }
                    Group{
                    Spacer().frame(height: 10)
                    
                    treatView
                    
                    Button(action: {
                        isShowAlertView.toggle()
//                        isShowPopUpView.toggle()
                    }, label: {
                        Image("addFrndIcon")
                    })
                    
                    Spacer().frame(height: 27)
                    
                    Text("FRIEND FEED 💝\n\n\n\nCOMING SOON...")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 14))
                    }
                    
                    NavigationLink(
                        destination: AddFriendPopupView(show: isShowPopUpView),
                        isActive: $isShowPopUpView){
                        
                    }
                    .alert(isPresented: $isShowAlertView, title: "Alert", message: "Feature not available")

                }

            }
            .onAppear{
                isShowAlertView.toggle()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

        
    }
}

struct GiftingView_Previews: PreviewProvider {
    static var previews: some View {
        GiftingView()
    }
}


struct AddFriendPopupView: View {
    
    @State var show: Bool
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        
        ZStack {
            if show{
                ScrollView{
                    Color.white.opacity(show ? 1 : 1).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                mode.wrappedValue.dismiss()
                            }, label: {
                                Text("Close")
                                    .foregroundColor(.black)
                                    .font(.custom("SourceSansPro-Regular", fixedSize: 18))
                            })
                            Spacer().frame(width:25)
                        }
                        Spacer().frame(height: 81)
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image("addFrndIconBig")
                        })
                        Spacer().frame(height: 70)
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Who's your friend")
                                .foregroundColor(.white)
                                .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                                .frame(width: UIScreen.main.bounds.width-80, height: 40)
                            
                        })
                        .background(Color.init(hex: "EEA35D"))
                        .frame(width: UIScreen.main.bounds.width-80, height: 40)
                        .cornerRadius(20)
                        
                        Spacer().frame(height: 121)
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("ADD")
                                .foregroundColor(.white)
                                .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                                .frame(width: UIScreen.main.bounds.width-250, height: 40)
                            
                        })
                        .background(Color.init("AppThemeMusturd"))
                        .frame(width: UIScreen.main.bounds.width-250, height: 40)
                        
                    }
                    
                }
                //.frame(width: UIScreen.main.bounds.width-20, height: 630)
                .background(Color.white)
//                .cornerRadius(10)
//                .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, eoFill: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//                .shadow(color: .gray, radius: 5, x: 1, y: 1)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)

            }
        }
    }
    
}

struct AddFriendPopupView_Previews: PreviewProvider {
    static var previews: some View{
        AddFriendPopupView(show: true)
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 630))
    }
}
