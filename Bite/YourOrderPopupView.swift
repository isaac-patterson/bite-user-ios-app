//
//  YourOrderPopupView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 15/07/21.
//

import SwiftUI

class OrderDetails: ObservableObject {
    @Published var orderData = [OrderModel]()
}
///make a global object for handle order details
var globalOrderData = [OrderModel]()

struct YourOrderPopupView<T: View>: ViewModifier {
    
    //MARK:- cart view
    ///its open like a popup
    let popup: T
    let isPresented: Bool
    @EnvironmentObject var orderList: OrderDetails
    @State var order = [OrderModel]()
    @State var isShowCheckoutView = false
    @Environment(\.presentationMode) private var presentationMode
    
    
    init(isPresented: Bool, @ViewBuilder content: () -> T) {
        self.isPresented = isPresented
        popup = content()
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(popupContent())
        
    }
    
    @ViewBuilder private func popupContent() -> some View {
        GeometryReader { geometry in
            if isPresented{
                body
                    .onAppear(perform: {
                        order = globalOrderData
                    })
                    .animation(.spring())
                    .transition(.offset(x: 0, y: geometry.belowScreenEdge))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
            }
        }
    }
    
    var listView: some View {
        List {
            ForEach(order) { item in
                VStack{
                    HStack(alignment:.top){
                        Spacer().frame(width: 18)
                        
                        Text(String(item.quantity))
                            .font(.custom("SourceSansPro-Light", size: 16))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        
                        Spacer().frame(width: 10)
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.custom("SourceSansPro-Light", size: 16))
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            
                        }
                        
                        Spacer()
                        VStack {
                            if item.offerPrice != 0{
                                Text("$\(item.offerPrice, specifier: "%.2f")")
                                    .font(.custom("SourceSansPro-Regular", size: 16))
                                    .foregroundColor(Color.init("AppThemeMusturd"))
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            }else{
                                Text("$\(item.price, specifier: "%.2f")")
                                    .font(.custom("SourceSansPro-Regular", size: 16))
                                    .foregroundColor(Color.init("AppThemeMusturd"))
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                
                            }
                            
                            Button(action: {
                                self.deleteOrder(at: self.order.firstIndex(where: {$0.id == item.id})!)
                            }, label: {
                                Image("deleteIcon")
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer().frame(width: 25)
                        
                    }
                    Spacer().frame(height: 10)
                    HStack(alignment:.top){
                        Spacer().frame(width: 35)
                        let exP = getExtraP(price: item.price, offerPrice: item.offerPrice, fprice: item.finalPrice)
                        VStack(alignment:.leading){
                            Text("Extra Options ")
                                .font(.custom("SourceSansPro-Regular", size: 16))
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            Spacer().frame(height: 5)
                            let extraOp = getItemOptions(arr: item.orderItemOptions!)
                            if extraOp != ""{
                                Text(extraOp)
                                    .font(.custom("SourceSansPro-Light", size: 16))
                            }
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
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(PlainListStyle())
        .environment(\.horizontalSizeClass, .regular)
        
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer().frame(height: 18)
                Text("YOUR ORDER")
                    .font(.custom("Quicksand-Bold", fixedSize: 30))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                Spacer().frame(height:46)
                
                listView
                
                Spacer().frame(height:0)
                HStack{
                    let total = countTotalPrice()
                    Spacer().frame(width:18)
                    Text("Total")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                    Spacer()
                    Text("$\(total, specifier: "%.2f")")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                    Spacer().frame(width:25)
                }
                .frame(height: 50)
                Spacer()
                
                NavigationLink(destination: CheckoutView(),
                               isActive: $isShowCheckoutView)
                {
                    
                }
                Group{
                    Button(action: {
                        if globalOrderData.count > 0{
                            isShowCheckoutView.toggle()
                        }
                    }, label: {
                        Text("GO TO CHECKOUT")
                            .foregroundColor(.white)
                            .font(.custom("Quicksand-Bold", fixedSize: 20))
                            .frame(width: UIScreen.main.bounds.width-135, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                    })
                    .background(globalOrderData.count > 0 ? Color.init("AppThemeMusturd") : Color.gray)
                    .cornerRadius(30)
                    .disabled(globalOrderData.count > 0 ? false : true)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .edgesIgnoringSafeArea(.all)
        
    }
        
    //MARK:- delete order from cart list
    func deleteOrder(at index: Int) {
        order.remove(at: index)
        globalOrderData.remove(at: index)
        
    }
    
    //MARK:- count total price of all food items in cart
    func countTotalPrice() -> Float{
        var totalPrice = Float()
        for i in globalOrderData {
            totalPrice += Float(i.finalPrice)
        }
        
        return totalPrice
    }
    
    //MARK:- make a single string of extra item options
    func getItemOptions(arr : [[String:String]]) -> String {
        var strArr = [String]()
        for i in arr {
            strArr.append(i["value"]!)
        }
        
        return strArr.joined(separator: ", ")
    }
    
    //MARK:- count extra price of extra item options
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

extension GeometryProxy {
    var belowScreenEdge: CGFloat {
        UIScreen.main.bounds.height - frame(in: .global).minY
    }
}


struct YourOrderPopupView_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .modifier(YourOrderPopupView(isPresented: true, content: {
                Color.clear.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }))
    }
}

struct OrderListItemView: View {
    
    var quantityNo: String
    var foodName: String
    var foodPrice: String
    
    var body: some View{
        VStack{
            HStack(alignment:.top){
                Spacer().frame(width: 18)
                Text(quantityNo)
                    .font(.custom("SourceSansPro-Light", size: 16))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer().frame(width: 10)
                Text(foodName)
                    .font(.custom("SourceSansPro-Light", size: 16))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Spacer()
                VStack {
                    Text("$\(foodPrice)")
                        .font(.custom("SourceSansPro-Regular", size: 16))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Button(action: { 
                        print("Click working................")
                    }, label: {
                        Image("deleteIcon")
                    })
                }
                
                Spacer().frame(width: 25)
                
            }
            Spacer().frame(height: 10)
            HStack(alignment:.top){
                Spacer().frame(width: 35)
                VStack(alignment:.leading){
                    Text("Extra Options ")
                        .font(.custom("SourceSansPro-Regular", size: 16))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer().frame(height: 5)
                    Text("")
                        .font(.custom("SourceSansPro-Light", size: 16))
                        .truncationMode(.tail)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .lineLimit(nil)
                    
                }
                Spacer()
                Text("$22.00")
                    .font(.custom("SourceSansPro-Regular", size: 16))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer().frame(width: 25)
            }
            Spacer().frame(height: 10)
            
        }
    }
}

struct orderListItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListItemView(quantityNo: "1", foodName: "Demo Food", foodPrice: "12.50")
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 200))
    }
}
