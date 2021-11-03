//
//  PaymentMethodsView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 15/07/21.
//

import SwiftUI
import Stripe
import Introspect
///delegate protocol for send user seleted card detail
protocol SelectCardDetailDelegate {
    func selectCard(cardPara: STPPaymentMethodCardParams, isCardSave: Bool?, savedCardData: CardDetailModel?)
}

struct PaymentMethodsView: View, CardDetailDelegate, CardRemoveDelegate {
  
    var from = ""
    var delegate: SelectCardDetailDelegate
    @State var isShowCardView = false
    @State var isShowCard = false
    @State var isShowChangePaymentView = false
    @State var isShowSideMenu = false
    @State var uiTabarController: UITabBarController?
    @ObservedObject var fetcher = CardDetailFetcher()
    @ObservedObject var userData = UserDataModel.shared
    @Binding var rootisActive : Bool
    
    
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    NavigationBarView()
                    Spacer().frame(height:0)
                    Divider()
                    Spacer().frame(height:35)
                }
                Group{
                    HStack{
                        Spacer().frame(width:20)
                        Text("payment methods")
                            .font(.custom("Quicksand-Medium", size: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    Spacer().frame(height:35)
                    List(){
                        if fetcher.loading {
                            CircleLoader()
                        }

                        ForEach(fetcher.cardListData){ index in
                            ZStack{
                                
                                if (from == "Checkout") {
                                    Button {
                                        let cardPara = STPPaymentMethodCardParams()
                                        delegate.selectCard(cardPara: cardPara, isCardSave: false, savedCardData: index)
//                                        self.presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Text("")
                                    }


                                }else{
                                    NavigationLink(destination: ChangePaymentModeView(cardData: [index], delegate: self)){
                                    }.hidden()
                                }
                                
                                PaymentMethodsListItemView(iconName: index.brand, titleName: "**********\(index.last4)")
                                
                            }
                            .listRowInsets(EdgeInsets())
                            .frame(height: 50)
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 50*CGFloat(fetcher.cardListData.count))

                }
                Spacer().frame(height:10)
                HStack{
                    Spacer().frame(width: 18)
                    
                    Image("plusicon")
                        .frame(width: 34, height: 27, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(width: 21)
                    
                    Text("add payment method")
                        .font(.custom("Quicksand-Medium", size: 16))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    
                }
                .sheet(isPresented: $isShowCard, content: {
                    CardDetailView(onlySave: false, delegate: self, shouldPopToRootView: $rootisActive)
                })
                .onTapGesture(perform: {
                    isShowCardView.toggle()
                    if from == "Checkout"{
                        isShowCard.toggle()
                    }
                })
                Spacer().frame(height: 40)
                HStack{
                    Spacer().frame(width: 20)
                    Image("StripeLogo")
                        .resizable()
                        .frame(width: 50,height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(width: 15)

                    Text("Protected by stripe")
                        .font(.custom("Quicksand-Bold", size: 18))
                        .foregroundColor(Color.appThemeMustured)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                
                if from == "Checkout"{
//                    NavigationLink(destination: CardDetailView(onlySave: false, delegate: self, shouldPopToRootView: $rootisActive),isActive: $isShowCardView)
//                    {
//
//                    }.isDetailLink(false)
                }else{
                    NavigationLink(destination: CardDetailView(onlySave: true, delegate: self, shouldPopToRootView: $rootisActive),isActive: $isShowCardView)
                    {
                        
                    }
                }
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }

        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
    }
    
    func sendCardParams(cardPara: STPPaymentMethodCardParams, response: CardDetailModel?, isCardSave: Bool?) {
        if response != nil{
        fetcher.cardListData.append(response!)
        }
        delegate.selectCard(cardPara: cardPara, isCardSave: isCardSave, savedCardData: nil)
    }
    
    func cardRemove(isDone: Bool?, removedCard: CardDetailModel?) {
        var index = -1
        for i in fetcher.cardListData {
            index += 1
            if i.id == removedCard?.id{
                fetcher.cardListData.remove(at: index)
            }
        }
        
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView(delegate: self as! SelectCardDetailDelegate, rootisActive: .constant(true))
    }
}

struct PaymentMethodsListItemView: View {
    
    var iconName: String
    var titleName: String
    
    var body: some View{
        VStack{
            HStack{
                Spacer().frame(width: 18)
                
                Image(iconName)
                    .frame(width: 34, height: 27, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(width: 21)
                
                Text(titleName)
                    .font(.custom("Quicksand-Medium", size: 16))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Image("rightArrowIcon")
                
                Spacer().frame(width: 10)
            }
        }
    }
}

struct PaymentMethodsListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsListItemView(iconName: "applepayIcon", titleName: "apple pay")
            .previewLayout(.fixed(width: 310, height: 60))
        
    }
}
//MARK:- saved card list api
class CardDetailFetcher: ObservableObject {
    @Published var cardListData = [CardDetailModel]()
    @Published var loading = false
    
    init() {
        getCardList()
    }
    
    func getCardList() {
        loading = true
        let urlEncoded = LoginUserModel.shared.data.user_idWORegionStr.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        let url = URL(string: "https://biteapp.work/user/api/CardToken/\(urlEncoded!)")!
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                
                if let d = data {
                    let decodedLists = try JSONDecoder().decode(CardDetailModelData.self, from: d)
                    DispatchQueue.main.async {
                        self.cardListData = decodedLists.data
                        self.loading = false
                    }
                    
                }else {
                    self.loading = false
                    print("No Data")
                }
            } catch let parsingError {
                self.loading = false
                print ("Error", parsingError)
            }
            
        }.resume()
        
    }
}
