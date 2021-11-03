//
//  CheckoutView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 15/07/21.
//

import SwiftUI
import UIKit
import Foundation
import Stripe

struct CheckoutView: View,SelectCardDetailDelegate {
    
    @State var isShowPickupView = false
    @State var isShowPaymentMethodsView = false
    @State var isShowEnterCouponCodeView = false
    @State var isClickOnCouponField = false
    @State var couponCode = ""
    @State var couponDetail : CouponModel?
    @State var totalPrice : Float = 0.0
    @State var isShowAlertView = false
    @State var alertMsg = ""
    @State var cardType = "Select Payment Method"
    @State var cardParams = STPPaymentMethodCardParams()
    @State var loading = false
    @State var cardTokenId = 0
    @State var orderID = 0
    @State var isCardSaveForFuture = Bool()
    @State var isShowProfileView = false
    @State var isActive = false
    @State var asapButtonSelect = false
    @State var specTimeButtonSelect = false
    @State var selectPickupTime = false
    @State var specificDateTime = "specified Time"
    @State var showDatePicker = false
    @State var date = Date()
    @State var popoverSize = CGSize(width: 320, height: 400)
    let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
        return formatter
    }()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var navigation  : some View {
        VStack{
            HStack(alignment: .center){
                
                Spacer().frame(width:16)
                
                VStack(alignment: .leading){
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }, label: {
                        Image("backIcon")
                    })
                    .frame(width: 35, height: 55, alignment: .leading)
                }
                
                
                Spacer()
                
                Text("bite")
                    .font(.custom("Quicksand-Bold", fixedSize: 45))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer()
                
                Button(action: {
                    isShowProfileView.toggle()
                }, label: {
                    Image("Info Icon")
                }).hidden()
                
                Spacer().frame(width:35)
            }
            .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Spacer().frame(height: 0)
            NavigationLink(destination: ProfileView(),isActive: $isShowProfileView){
                
            }.isDetailLink(false)
            
            Divider()
        }
        
    }
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    navigation
                    Group{
                        Text("YOUR ORDER")
                            .font(.custom("Quicksand-Bold", fixedSize: 30))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                        Spacer().frame(height: 10)
                        //                    HStack{
                        //                        Text("projected pick up time:")
                        //                            .font(.custom("Quicksand-Regular", fixedSize: 15))
                        //                        Text("11:23am")
                        //                            .font(.custom("Quicksand-Bold", fixedSize: 15))
                        //
                        //                    }
                        
                        Spacer().frame(height:16)
                        List{
                            ForEach(globalOrderData){ item in
                                CheckoutListItemView(orderData: item)
                                    .listRowInsets(EdgeInsets())
                                    .frame(height: 110)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .environment(\.horizontalSizeClass, .regular)
                        .frame(height: 110*CGFloat(globalOrderData.count))
                        
                    }
                    Group{
                        Spacer().frame(height:20)
                        HStack{
                            Spacer().frame(width:25)
                            Text("Total")
                                .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                            Spacer()
                            Text("$\(totalPrice, specifier: "%.2f")")
                                .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                            Spacer().frame(width:25)
                        }
                        .onAppear {
                            totalPrice = countTotalPrice()
                        }
                    }
                    Spacer().frame(height:20)
                    Group{
                        Text("Select Pickup Time")
                            .font(.custom("SourceSansPro-Bold", fixedSize: 18))
                            .foregroundColor(Color.appThemeMustured)
                        HStack{
                            Spacer().frame(width: 15)
                            HStack {
                                Button(action: {
                                }, label: {
                                    Image(systemName: asapButtonSelect ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(asapButtonSelect ? .appThemeMustured : .gray)
                                        .font(.title2)
                                })
                                .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                Spacer().frame(width: 5)
                                Text("ASAP")
                                    .font(.custom("SourceSansPro-Light", fixedSize: 18))
                                
                                Spacer()
                            }
                            .onTapGesture {
                                asapButtonSelect.toggle()
                                specTimeButtonSelect = false
                                selectPickupTime = asapButtonSelect
                            }
                            Divider()
                            Spacer().frame(width: 15)
                            WithPopover(showPopover: $showDatePicker, popoverSize: popoverSize) {
                                
                                HStack {
                                    Button(action: {
                                    }, label: {
                                        Image(systemName: specTimeButtonSelect ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(specTimeButtonSelect ? .appThemeMustured : .gray)
                                            .font(.title2)
                                    })
                                    .frame(width: 45, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    Spacer().frame(width: 5)
                                    Text(specificDateTime)
                                        .font(.custom("SourceSansPro-Light", fixedSize: 18))
                                    Spacer()
                                }
                                .onTapGesture {
                                    self.showDatePicker.toggle()
                                }
                                
                                
                                
                            } popoverContent: {
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(.bottom, -40)
                            }
                            .onChange(of: date, perform: { value in
                                self.specificDateTime = dateformatter.string(from: date)
                                specTimeButtonSelect = true
                                asapButtonSelect = false
                                selectPickupTime = specTimeButtonSelect
                            })
                            
                            Spacer().frame(width: 15)
                        }
                    }
                    Group{
                        Spacer().frame(height:25)
                        NavigationLink(destination: PaymentMethodsView(from: "Checkout", delegate: self, rootisActive: $isActive),isActive: $isShowPaymentMethodsView){
                        }.isDetailLink(false)
                        HStack{
                            Spacer().frame(width:16)
                            Image("paymenticon")
                            Spacer()
                            Text("Payment Method - ")
                                .font(.custom("SourceSansPro-Light", fixedSize: 16)) +
                                
                                Text("\(cardType)")
                                .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                            Spacer()
                            Image("rightArrowIcon")
                            Spacer().frame(width: 16)
                            
                        }
                        .onTapGesture(perform: {
                            isShowPaymentMethodsView.toggle()
                        })
                        .frame(width: UIScreen.main.bounds.width-44,height: 55)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 0.5) )
                        
                        Spacer().frame(height:25)
                        HStack{
                            Spacer()
                            
                            
                            TextField("Discount Code", text: $couponCode, onEditingChanged: { isChange in
                            }, onCommit: {
                                self.couponCodeApi()
                            })
                            .font(.custom("SourceSansPro-Bold", fixedSize: 18))
                            .multilineTextAlignment(.center)
                            Spacer()
                            
                        }
                        .onTapGesture(perform: {
                            // isShowEnterCouponCodeView.toggle()
                            
                        })
                        .frame(width: UIScreen.main.bounds.width-44,height: 55)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 0.5))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: PickupPageView(orderId: orderID),isActive: $isShowPickupView)
                    {
                        
                    }.isDetailLink(false)
                    Button(action: {
                        if cardParams.number != nil || cardTokenId != 0 && selectPickupTime{
                            createOrderApi()
                        }else if !selectPickupTime{
                            self.alertMsg = "Please Select a pickup time"
                            self.isShowAlertView.toggle()
                        }else if cardParams.number == nil || cardTokenId == 0{
                            self.alertMsg = "Please Select a card for payment"
                            self.isShowAlertView.toggle()
                        }
                    }, label: {
                        if loading {
                            CircleLoader()
                                .frame(height: 50)
                        }else{
                            Text("PLACE ORDER")
                                .foregroundColor(.white)
                                .font(.custom("Quicksand-Bold", fixedSize: 20))
                                .frame(width: UIScreen.main.bounds.width-135, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        }
                    })
                    .background(Color.init("AppThemeMusturd"))
                    .cornerRadius(30)
                    .padding(.init(top: 50, leading: 0, bottom: 50, trailing: 0))
                    
                    .alert(isPresented: $isShowAlertView, title: "Alert", message: alertMsg)
                    
                    if self.isShowEnterCouponCodeView {
                        AlertControlView(textString: $couponCode, showAlert: $isShowEnterCouponCodeView, title: "Enter Discount Code", message: "")
                    }
                    
                    
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onChange(of: couponCode) { newValue in
            }
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    ///delegate function for get data from card list screen
    func selectCard(cardPara: STPPaymentMethodCardParams, isCardSave: Bool?, savedCardData: CardDetailModel?) {
        if savedCardData == nil {
            let brand = STPCardValidator.brand(forNumber: cardPara.number!)
            self.cardType = STPCardBrandUtilities.stringFrom(brand)!
            self.cardParams = cardPara
        }else{
            self.cardType = savedCardData!.brand
            self.cardTokenId = savedCardData!.id
        }
        self.isCardSaveForFuture = isCardSave!
        isShowPaymentMethodsView = false
    }
    
    
    ///count total price
    func countTotalPrice() -> Float{
        var totalPrice = Float()
        for i in globalOrderData {
            totalPrice += Float(i.finalPrice)
        }
        
        return totalPrice
    }
    
    //MARK:- Discount Coupon code api
    func couponCodeApi()
    {
        //TEST%20COUPON
        loading = true
        guard let url = URL(string: "https://biteapp.work/user/api/Coupon/Get/\(couponCode.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")") else { return }
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                loading = false
                if let d = data {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        print("RESPONSE ******************+++++++++++++++++****************", json)
                        if (json["error"] as? String) != nil{
                            self.alertMsg = (json["error"] as? String)!
                            self.isShowAlertView.toggle()
                            
                        }
                        self.couponCode = ""
                    }
                    let decodedLists = try JSONDecoder().decode(CouponModelData.self, from: d)
                    DispatchQueue.main.async {
                        print(decodedLists)
                        self.alertMsg = "Discount Coupon Applied Successfully and you got \(String(decodedLists.data.discount)) discount"
                        self.isShowAlertView.toggle()
                        self.couponDetail = decodedLists.data
                        self.totalPrice = totalPrice - Float(decodedLists.data.discount)
                        self.couponCode = ""
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
    
    //MARK:- create order api
    func createOrderApi()
    {
        //TEST%20COUPON
        loading = true
        _ = NSDate().timeIntervalSince1970
        
        let orders = try? JSONEncoder().encode(globalOrderData)
        var orderArr = [[String:Any]]()
        if let orderjson = try? JSONSerialization.jsonObject(with: orders!, options: []) as? [[String: Any]] {
            // try to read out a string array
            orderArr = orderjson
        }
        let userName = UserDataModel.shared.data.name + " " + UserDataModel.shared.data.last_name
        let parameters = ["cognitoUserId" : LoginUserModel.shared.data.user_idWORegionStr!, "status" : "Pending", "createdDate" : formatDate(),"restaurantId" : globalOrderData[0].restaurantId,"total" : totalPrice, "currency" : "NZD","orderItems" : orderArr, "pickupName" : userName,"couponId" : self.couponDetail?.couponId ?? 0] as [String : Any]
        
        
        print(parameters)
        
        NetworkManager.callService(url: "order/create", parameters: parameters) { response in
            switch response
            {
            case .success(let responseData):
                loading = false
                print(responseData)
                let data = responseData["data"] as! [String:Any]
                let orderId = data["orderId"] as! Int
                self.orderID = orderId
                makePaymentApi(orderid: orderId)
                break
            case .failed(let error):
                loading = false
                print(error)
                break
            }
            loading = false
        }
        
        
    }
    
    func formatDate() -> String {
        let date = Date()
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateString = dayTimePeriodFormatter.string(from: date)
        return dateString
    }
    
    //MARK:- make payment api
    func makePaymentApi(orderid: Int) {
        loading = true
        _ = URL(string: "https://biteapp.work/user/api/Payment/Charge")!
        
        var parameters: [String : Any] = ["":""]
        
        if cardTokenId == 0 {
            ///parameters for new card payment
            parameters = ["senderCognitoId" : LoginUserModel.shared.data.user_idWORegionStr!, "cardNumder" : cardParams.number!, "month" : cardParams.expMonth!, "year" : cardParams.expYear!, "cvc" : cardParams.cvc!, "amount" : (totalPrice*100),"orderId" : orderid, "isAllowToSave" : isCardSaveForFuture,"emailId" : UserDataModel.shared.data.email!]
        }else{
            ///parameters for already saved card
            parameters = ["senderCognitoId" : LoginUserModel.shared.data.user_idWORegionStr!, "cardTokenId" : cardTokenId,"orderId" : orderid, "amount" : (totalPrice*100),"emailId" : UserDataModel.shared.data.email!]
        }
        
        
        NetworkManager.callService(url: "Payment/Charge", parameters: parameters) { response in
            switch response
            {
            
            case .success(let responseData):
                print(responseData)
                loading = false
                _ = responseData["data"]
                alertMsg = "Payment succeeded.\nYour Order successfully Placed"
                // isShowAlertView.toggle()
                isShowPickupView.toggle()
                break
            case .failed(let error):
                loading = false
                print(error)
                break
            }
            loading = false
        }
        
        
    }
}



struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
//MARK:- list item sub view
struct CheckoutListItemView: View {
    
    var orderData : OrderModel
    
    var body: some View{
        VStack{
            HStack(alignment:.top){
                Spacer().frame(width: 25)
                Text("\(orderData.quantity)")
                    .font(.custom("SourceSansPro-Light", size: 16))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer().frame(width: 10)
                Text(orderData.name)
                    .font(.custom("SourceSansPro-Light", size: 16))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Spacer()
                Text("$\(orderData.price, specifier: "%.2f")")
                    .font(.custom("SourceSansPro-Regular", size: 16))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(width: 25)
                
            }
            Spacer().frame(height: 10)
            HStack(alignment:.top){
                Spacer().frame(width: 42)
                let exP = getExtraP(price: orderData.price, offerPrice: orderData.offerPrice, fprice: orderData.finalPrice)
                VStack(alignment:.leading){
                    Text("Extra Options ")
                        .font(.custom("SourceSansPro-Regular", size: 16))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer().frame(height: 5)
                    Text(getItemOptions(arr: orderData.orderItemOptions!))
                        .font(.custom("SourceSansPro-Light", size: 16))
                        .lineLimit(nil)
                    
                }
                Spacer()
                Text("$\(exP, specifier: "%.2f")")
                    .font(.custom("SourceSansPro-Regular", size: 16))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer().frame(width: 25)
            }
            Spacer().frame(height: 10)
            
        }
    }
    
    func getItemOptions(arr : [[String:String]]) -> String {
        var strArr = [String]()
        for i in arr {
            strArr.append(i["value"]!)
        }
        
        return strArr.joined(separator: ", ")
    }
    
    func getExtraP(price : Float, offerPrice : Float, fprice : CGFloat) -> Float
    {
        var p = price
        if offerPrice > 0{
            p = offerPrice
        }
        let extraP = Float(fprice) - p
        return extraP
    }
    
}

//struct CheckoutListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckoutListItemView(orderData: )
//            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 50))
//    }
//}

class CheckoutPaymentFetcher: UIViewController, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    
    var cardParamters = STPPaymentMethodCardParams()
    var paymentIntent = "pi_3JKh7pLiID1kXMzT3neetdf0"
    
    override func viewDidLoad() {
    }
    
    func pay(completion: @escaping STPPaymentHandlerActionPaymentIntentCompletionBlock) {
        let paymentIntentClientSecret = paymentIntent
        // Collect card details
        let cardParams = self.cardParamters
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        paymentIntentParams.setupFutureUsage = STPPaymentIntentSetupFutureUsage.offSession
        
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                print("Payment failed \(String(describing: error?.localizedDescription))")
                // self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                break
            case .canceled:
                print("Payment canceled \(String(describing: error?.localizedDescription))")
                //self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
                print("Payment succeeded \(String(describing: paymentIntent?.description))")
                // self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
                break
            @unknown default:
                fatalError()
                break
            }
            completion(status, paymentIntent, error)
        }
    }
    
}
