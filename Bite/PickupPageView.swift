//
//  PickupPageView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 15/07/21.
//

import SwiftUI
import UIKit
import Foundation

struct PickupPageView: View {
    
    var orderId = 0
    @ObservedObject var fetcher = OrderDetailFetcher()
    @ObservedObject var orderData = OrderStatusModel.shared
    let timer = Timer.publish(every: 5, on: .current, in: .common).autoconnect()

    var body: some View {
        CustomNavigationView(isHideBackButton: true,isHideProfileButton: true)
        Spacer()
        Divider()
        ScrollView(showsIndicators: false){
            VStack{
                Group{
                    Spacer().frame(height:62)
                    Image("")
                        .padding(.leading, UIScreen.main.bounds.width-60)
                        .onTapGesture {
                        }
                    Text("Your order will be ready at")
                        .font(.custom("Quicksand-Bold", fixedSize: 20))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                    Spacer().frame(height:40)
                    let time = convertDateFormatter(date: orderData.data.pickupDate)
                    Text(time)
                        .font(.custom("Quicksand-Bold", fixedSize: 40))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                }
                Group{
                    Spacer().frame(height:65)
                    HStack{
                        Image("pending")
                        Text("Order Pending")
                            .font(.custom("Quicksand-Bold", fixedSize: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }
                    if orderData.data.status.lowercased() == "pending" || orderData.data.status.lowercased() == "confirmed" || orderData.data.status.lowercased() == "pickedup"{
                        Image("doneIcon")
                            .frame(height:60)
                    }else{
                        Image("")
                            .frame(height:60)
                    }
                    HStack{
                        Image("orderReceivedIcon")
                        Text("Order Confirmed")
                            .font(.custom("Quicksand-Bold", fixedSize: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }
                    if orderData.data.status.lowercased() == "confirmed" || orderData.data.status.lowercased() == "pickedup"{
                        Image("doneIcon")
                    }else{
                        Image("")
                            .frame(height:60)
                    }
                    HStack{
                        Image("prepareOrderIcon")
                        Text("Ready for pick up!")
                            .font(.custom("Quicksand-Bold", fixedSize: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }
                    if orderData.data.status.lowercased() == "pickedup"{
                        Image("doneIcon")
                    }else{
                        Image("")
                            .frame(height:60)
                    }
                }
                Spacer().frame(height:20)

                
            }

        }
        .onAppear(perform: {
            fetcher.getOrderDetail(id: orderId)
            getOrderStatus()
            globalOrderData.removeAll()
        })
        .onReceive(timer, perform: { time in
            ///call get order status api in every 5 sec
            getOrderStatus()
            
        })
        .onDisappear(perform: {
            self.timer.upstream.connect().cancel()
        })
        .frame(width: UIScreen.main.bounds.width)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)


    }
    
    func convertDateFormatter(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
//            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "HH:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        return timeStamp
    }

    //MARK:- api for get order status
    func getOrderStatus()
    {
        if orderId == 0 {
            return
        }
        let url = URL(string: "https://biteapp.work/user/api/order/GetStatusById/status/\(orderId)")!
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                if data != nil {
                    
                    if let orderjson = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let data = orderjson["data"] as? [String:Any]{
                                OrderStatusModel.shared.data.status = data["status"] as? String
                                OrderStatusModel.shared.data.pickupDate = data["pickupDate"] as? String
                                OrderStatusModel.shared.data.orderId = data["orderId"] as? Int
                                
                            }
                        }
                        
                    }
                    
                    
                }else {
                    print("No Data")
                }
            }
//            catch let parsingError {
//                print ("Error", parsingError)
//            }
            
        }.resume()
        
    }
}

struct PickupPageView_Previews: PreviewProvider {
    static var previews: some View {
        PickupPageView()
    }
}
//MARK:- order detail api
class OrderDetailFetcher: ObservableObject {
    @Published var loading = false
    @Published var pickupOrderData : [String:Any] = ["":""]
    
    func getOrderDetail(id : Int)
    {
        //TEST%20COUPON
        loading = true
        guard let url = URL(string: "https://biteapp.work/user/api/Order/GetById/\(id)") else { return }
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                if let d = data {
                    if let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String: Any] {
                        print(json)
                        DispatchQueue.main.async {
                        self.pickupOrderData = json["data"] as! [String : Any]
                        }
                    }
                    _ = try JSONDecoder().decode(PickupOrderModelData.self, from: d)
                    DispatchQueue.main.async {
                        self.loading = false
                    }
                }else {
                    self.loading = false
                    print("No Data")
                }
            } catch let parsingError {
                DispatchQueue.main.async {
                    self.loading = false
                }
                print ("Error", parsingError)
            }
            
        }.resume()
        
    }
}
