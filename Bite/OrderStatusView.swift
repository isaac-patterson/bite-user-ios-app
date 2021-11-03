//
//  OrderStatusView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 20/08/21.
//

import SwiftUI
import UIKit
import Foundation

struct OrderStatusView: View {
    
    var orderId = 0
    @ObservedObject var orderData = OrderStatusModel.shared
    let timer = Timer.publish(every: 5, on: .current, in: .common).autoconnect()
    
    var body: some View {
        CustomNavigationView()
            .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        Spacer().frame(height: 0)
        Divider()
        Spacer().frame(height:20)
        ScrollView{
            VStack{
                Group{
                    Image("")
                        .padding(.leading, UIScreen.main.bounds.width-60)
                        .onTapGesture {
                        }
                    
                    if orderData.data.status.lowercased() == "pending" {
                        Text("Your order is pending!")
                            .font(.custom("Quicksand-Bold", fixedSize: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }else if orderData.data.status.lowercased() == "confirmed"{
                        Text("Your order is confirmed!")
                            .font(.custom("Quicksand-Bold", fixedSize: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }else{
                        Text("Your order is ready for pick up!")
                            .font(.custom("Quicksand-Bold", fixedSize: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }
                    
                    Spacer().frame(height:40)
                    let id = orderId
                    Text("Order #\(String(id))")
                        .font(.custom("Quicksand-Bold", fixedSize: 35))
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
                if orderData.data.status.lowercased() == "pickedup"{
                    Text("go grab your order!")
                        .font(.custom("Quicksand-Regular", fixedSize: 20))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                        .foregroundColor(.white)
                        .padding(.horizontal, 65)
                        .frame(height:75)
                }
                Spacer().frame(height:40)
                let id = orderId
                Text("Order #\(String(id))")
                    .font(.custom("Quicksand-Bold", fixedSize: 35))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                
            }
            
        }
        .onAppear(perform: {
            getOrderStatus()
        })
        .onReceive(timer, perform: { time in
            ///call order status Api in every 5 sec and show status in screen
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
        print(timeStamp)
        return timeStamp
    }
    
    //MARK:- get order status api
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

struct OrderStatusView_Previews: PreviewProvider {
    static var previews: some View {
        OrderStatusView()
    }
}


