//
//  WalletView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI

struct WalletView: View {
    
    @State var searchText = ""
    @State var selectNo: Int?
    @State var isShowNextView = false
    var titleTextArr = ["Coffee from Cafe Strata  $3.50","Bagel from Shakey Isles $4.20 ","Chips from Hot Lips  $3.30 ","Poke from Ha Poke $5.90 ","Burrito from Taco Joint $4.00"]
    var imageNamArr = ["☕","🍰","🍗","🍚","🌮"]
    var bgColorArr = ["FFC8C8","97D2F2","F1C8FF","D0C8FF","C8E5FF"]
    @State var isShowAlertView = false

    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    CustomNavigationView(isHideBackButton: true)
                        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(height: 0)
                    
                    Divider()
                    
                    Spacer().frame(height:0)
                    
                    SearchBarView(text: $searchText)
                    
                    Spacer().frame(height:18)
                    
                    Text("Send a gift\n💌")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 14))
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 20)
                    
                    ScrollView{
                        LazyVStack{
                            ForEach(0..<titleTextArr.count)
                            {
                                index in
                                NavigationLink(destination: RedeemGiftPopView(),
                                               isActive: $isShowNextView){
                                }
                                
                                WalletListItem(titleText: titleTextArr[index], imageName: imageNamArr[index], bgColor: bgColorArr[index])
                                    .onTapGesture {
                                        isShowNextView = true
                                        selectNo = index
                                    }
                                Spacer().frame(height: 20)
                            }
                        }
                    }
                    Spacer().frame(height: 27)
                    
                .alert(isPresented: $isShowAlertView, title: "Alert", message: "Feature not available")

                }
                .onAppear(perform: {
                    isShowAlertView.toggle()
                })
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}

//MARK:- wallet list sub view or item
struct WalletListItem: View {
    
    var titleText: String
    var imageName: String
    var bgColor: String
    
    var body: some View {
        HStack{
            Spacer().frame(width: 29)
            Text(titleText)
                .foregroundColor(.white)
                .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                .padding(.horizontal, 50)
                .frame(height: 75)
            
            Spacer()
            
            Image(imageName)
            
            Spacer().frame(width: 20)
        }
        .padding(.horizontal, 10)
        .background(Color.init(hex: bgColor))
        .cornerRadius(20)
        .frame(width: UIScreen.main.bounds.width-20,height: 75)
        
    }
}

struct WalletListItem_Previews: PreviewProvider {
    static var previews: some View {
        WalletListItem(titleText: "Coffe from Cafe Strata", imageName: "☕", bgColor: "FFC8C8")
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 75))
        
    }
}


