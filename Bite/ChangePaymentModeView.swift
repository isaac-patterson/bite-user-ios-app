//
//  ChangePaymentModeView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 15/07/21.
//

import SwiftUI

protocol CardRemoveDelegate {
    func cardRemove(isDone: Bool?, removedCard: CardDetailModel?)
}

struct ChangePaymentModeView: View {
    
    @State var isShowPopupView = false
    @State var isShowEditView = false
    var cardData = [CardDetailModel]()
    @State var isShowAlertView = false
    var delegate: CardRemoveDelegate
    @State var loading = false
    @State var dismiss = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    CustomNavigationView()
                    Spacer().frame(height:0)
                    Divider()
                    Spacer().frame(height:20)
                }
                Group{
                    HStack{
                        Spacer().frame(width:20)
                        VStack(alignment:.leading){
                            Text(cardData[0].brand)
                                .font(.custom("Quicksand-Medium", fixedSize: 25))
                                .foregroundColor(Color.init("AppThemeMusturd"))
                            Text("********* \(cardData[0].last4)")
                                .font(.custom("Quicksand-Medium", fixedSize: 16))
                                .foregroundColor(Color.init("AppThemeMusturd"))
                        }
                        Spacer()
                        Image(cardData[0].brand)
                        Spacer().frame(width:20)
                    }
                    Spacer().frame(height:50)
                    HStack{
                        Spacer().frame(width:20)
                        VStack(alignment:.leading){
                            Text("expiry date")
                                .font(.custom("Quicksand-Medium", fixedSize: 14))
                                .foregroundColor(Color.init("AppThemeMusturd"))
                            Text("\(cardData[0].expMonth)/\(cardData[0].expYear)")
                                .font(.custom("Quicksand-Medium", fixedSize: 16))
                                .foregroundColor(Color.init("AppThemeMusturd"))
                        }
                        Spacer()
                        
                    }
                }
              //  Spacer().frame(height:50)
//                HStack(alignment:.top){
//                    Spacer().frame(width:10)
//                    Image("editIcon")
//                    Spacer().frame(width:10)
//                    VStack(alignment:.leading){
//                        Text("edit")
//                            .font(.custom("Quicksand-Medium", size: 16))
//                            .foregroundColor(Color.init("AppThemeMusturd"))
//                        Spacer().frame(height:25)
//                        Divider()
//                    }
//
//                    NavigationLink(destination: EditCardView(),
//                                   isActive: $isShowEditView){
//                    }
//                }
//                .onTapGesture(perform: {
//                    isShowEditView.toggle()
//                })
                Spacer().frame(height:40)
                HStack(alignment:.center){
                    Spacer().frame(width:10)
                    Image("cancelIcon")
                    Spacer().frame(width:10)
                    VStack(alignment:.leading){
                        Text("remove payment method")
                            .font(.custom("Quicksand-Medium", size: 16))
                            .foregroundColor(Color.init(hex: "CD2626"))
                    }
                    Spacer()
                }
                .onTapGesture(perform: {
                    isShowAlertView.toggle()
                    //isShowPopupView.toggle()
                })
                
                .alert(isPresented:$isShowAlertView) {
                    Alert(
                        title: Text("Remove payment method"),
                        message: Text(""),
                        primaryButton: .default(Text("Delete"), action: {
                            deleteCardApi()
                            
                        }),
                        secondaryButton: .default(Text("Cancel"), action: {
                            
                        })
                    )
                }
                if loading {
                    CircleLoader()
                }
                
            }
            .onChange(of: dismiss, perform: { newValue in
                if dismiss {
                    self.mode.wrappedValue.dismiss()
                }
            })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        }
        .modifier(RemovePaymentPopupView(isPresented: isShowPopupView, content: {
            Color.yellow.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }))
    }
    
    //MARK:- delete card api
    func deleteCardApi() {
        loading = true
        _ = String(cardData[0].id).addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        let url = URL(string: "https://biteapp.work/user/api/CardToken/\(String(cardData[0].id))")!
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                loading = false
                if let d = data {
                    if let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String: Any] {
                        print(json)
                        self.delegate.cardRemove(isDone: true, removedCard: cardData[0])
                        self.dismiss = true
                    }
                   
                }else {
                    print("No Data")
                }
            } catch let parsingError {
                loading = false
                print ("Error", parsingError)
            }
            
        }.resume()
        
    }
}

struct ChangePaymentModeView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePaymentModeView(delegate: self as! CardRemoveDelegate)
    }
}
