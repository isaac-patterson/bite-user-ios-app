//
//  ReceiptDetailView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 21/08/21.
//

import SwiftUI

struct ReceiptDetailView: View {
    
    @State var isShowOrderStatusView = false
    @EnvironmentObject var fetcher : OrderDetailsGet
    var id = 0
    
    var body: some View {
            VStack{
                Group{
                    CustomNavigationView()
                        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(height: 0)
                    Divider()
                    Spacer().frame(height:20)
                }
                List((fetcher.orderDetailArr?.orderItems ?? [])) { item in
                    if fetcher.loading{
                        CircleLoader()
                    }
                    ReceiptDetailListItemView(orderData: item)
                        .listRowInsets(EdgeInsets())
                }
                .listStyle(PlainListStyle())
                Spacer().frame(height:0)
                HStack{
                    let total = fetcher.orderDetailArr?.total
                    Spacer().frame(width:18)
                    Text("Total")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                    Spacer()
                    Text("$\(total ?? 0 , specifier: "%.2f")")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                    Spacer().frame(width:25)
                }
                .frame(height: 50)
                Spacer()
                Button(action: {
                    isShowOrderStatusView.toggle()
                }, label: {
                    Text("View Order Status")
                        .font(.custom("SourceSansPro-Regular", size: 18))
                        .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(25)
                .foregroundColor(.white)
                
                Spacer().frame(height:50)
                NavigationLink(destination: OrderStatusView(orderId: id),isActive: $isShowOrderStatusView){
                }
            }
            .onAppear(perform: {
                fetcher.orderId = id
                fetcher.getOrderDetail()
            })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptDetailView()
    }
}

struct ReceiptDetailListItemView: View {
    
    var orderData : OrderItemsModel
    
    var body: some View{
        VStack{
            HStack(alignment:.top){
                Spacer().frame(width: 30)
                VStack(alignment: .leading){
                    Text(orderData.name!)
                        .font(.custom("SourceSansPro-Light", size: 16))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                
                Spacer()
                Text("$\(orderData.price!, specifier: "%.2f")")
                    .font(.custom("SourceSansPro-Regular", size: 16))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(width: 10)
                
            }
            Spacer().frame(height: 10)
            
            HStack{
                Spacer().frame(width: 30)
                //let exP = getExtraP(arr: orderData.orderItemOptions!)
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
                let exP = getExtraP(arr: orderData.orderItemOptions!)
                Text("$\(exP, specifier: "%.2f")")
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .font(.custom("SourceSansPro-Regular", size: 16))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer().frame(width: 10)
                
            }
            Spacer().frame(height: 10)
        }
        
    }
    
    ///make single string of extra item options
    func getItemOptions(arr : [OrderItemOptionsModel]) -> String {
        var strArr = [String]()
        for i in arr {
            strArr.append(i.value!)
        }
        
        return strArr.joined(separator: ", ")
    }
    
    ///count extra price of item options
    func getExtraP(arr : [OrderItemOptionsModel]) -> Float
    {
        var p = Float()
        for i in arr {
            p += i.price!
        }
        return p
    }
}
//MARK:- api for get order detail
class OrderDetailsGet: ObservableObject {
    
    @Published var orderDetailArr : PickupOrderModel?
    @Published var loading = false
    @Published var isShowError = false
    @Published var orderId = 0
    
    init() {
        getOrderDetail()
    }
    
    func getOrderDetail()
    {
        if orderId == 0{
            return
        }
        loading = true
        let url = URL(string: "https://biteapp.work/user/api/order/GetById/\(orderId)")!
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
                    
                    if (try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]) != nil {
                    }
                    let decodedLists = try JSONDecoder().decode(OrderDetailModelData.self, from: d)
                    DispatchQueue.main.async {
                        print(decodedLists)
                        self.orderDetailArr = decodedLists.data
                    }
                }else {
                    print("No Data")
                }
            } catch let parsingError {
                self.loading = false
                print ("Error", parsingError)
            }
            
        }.resume()
        
    }
    
}
