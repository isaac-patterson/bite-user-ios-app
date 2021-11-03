//
//  ReceiptView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 19/08/21.
//

import SwiftUI
import UIKit
import Foundation

struct ReceiptView: View {
    
    @EnvironmentObject var fetcher : OrderFetch
    @State var filterOrderList = [PickupOrderModel]()
    @State var isShowDetailView = false
    var orderType = ""
    
    var body: some View {
        VStack{
            Group{
                CustomNavigationView()
                    .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(height: 0)
                Divider()
                Spacer().frame(height: 36)
                HStack {
                    Spacer().frame(width: 36)
                    if orderType == "past"{
                        Text("Past Order")
                            .font(.custom("Quicksand-Medium", size: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }else{
                        Text("Current Order")
                            .font(.custom("Quicksand-Medium", size: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                        
                    }
                    Spacer()
                }
                Spacer().frame(height: 15)
            }
            List() {
                if (fetcher.loading){
                    CircleLoader()
                }
                if fetcher.isShowError{
                    HStack{
                        Spacer()
                        Text(fetcher.msg)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                if self.orderType == "current"{
                ForEach(fetcher.orderList.filter{$0.status.lowercased() == "pending" || $0.status.lowercased() == "confirmed" }) { item in
                    ZStack{
                        NavigationLink(destination: ReceiptDetailView(id: item.orderId).environmentObject(OrderDetailsGet())) {
                        }.hidden()
                        ReceiptListItemView(data: item)
                            .frame(height:60)
                            .listRowInsets(.none)
                    }
                }
                }else{
                    ForEach(fetcher.orderList.filter{ $0.status.lowercased() == "pickedup" }) { item in
                        ZStack{
                            NavigationLink(destination: ReceiptDetailView(id: item.orderId).environmentObject(OrderDetailsGet())) {
                            }.hidden()
                            ReceiptListItemView(data: item)
                                .frame(height:60)
                                .listRowInsets(.none)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onReceive(fetcher.$orderList, perform: { _ in
                if self.orderType == "current"{
                    self.filterOrderList = fetcher.orderList.filter{ $0.status.lowercased() == "pending" || $0.status.lowercased() == "confirmed"
                    }
                    
                }else{
                    self.filterOrderList = fetcher.orderList.filter{ $0.status.lowercased() == "pickedup" }
                }
            })
            
        }
        .onAppear(perform: {
            fetcher.getAllOrderList()
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView()
            .environmentObject(OrderFetch())
    }
}

class OrderFetch: ObservableObject {
    
    @Published var orderList = [PickupOrderModel]()
    @Published var loading = false
    @Published var isShowError = false
    @Published var msg = ""
    @Published var type = ""
    
    init() {
        getAllOrderList()
    }
    
    func getAllOrderList()
    {
        loading = true
        let urlEncoded = LoginUserModel.shared.data.user_idWORegionStr.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let url = URL(string: "https://biteapp.work/user/api/order/getAll/\(urlEncoded ?? "")")!
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                DispatchQueue.main.async {
                    self.loading = false
                }
                if let d = data {
                    
                    if let orderjson = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if orderjson["error"] != nil {
                            DispatchQueue.main.async {
                                self.loading = false
                                self.isShowError = true
                                self.msg = orderjson["error"] as! String
                                print(orderjson)
                            }
                        }
                    }
                    let decodedLists = try JSONDecoder().decode(PickupOrderModelData.self, from: d)
                    DispatchQueue.main.async {
                        print(decodedLists)
                        self.orderList = decodedLists.data
                    }
                }else {
                    print("No Data")
                }
            } catch let parsingError {
                DispatchQueue.main.async {
                    self.loading = false
                    print ("Error", parsingError)
                }
            }
            
        }.resume()
        
    }
    
}

struct ReceiptListItemView: View {
    
    var data : PickupOrderModel
    
    var body: some View {
        VStack{
            HStack{
                Spacer().frame(width: 16)
                Text(data.restaurantInfo!.name)
                    .font(.custom("Quicksand-Medium", size: 16))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                Spacer()
                Text(convertDateFormatter(date: data.createdDate))
                    .font(.custom("Quicksand-Medium", size: 16))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                Spacer().frame(width: 30)
                Image("rightArrowIcon")
                Spacer().frame(width: 16)
            }
        }
    }
    
    func convertDateFormatter(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        return timeStamp
        
    }
    
}

