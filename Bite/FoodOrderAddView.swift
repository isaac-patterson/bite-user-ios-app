//
//  FoodOrderAddView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 15/07/21.
//

import SwiftUI
import Introspect

struct FoodOrderAddView: View,MenuItemOptionDelegate {
    
    @State var quantitlyTextVal = "1"
    @State var isShowOrderView = false
    @State var isShowAlertView = false
    @State var isShowMenuItemOption = false
    @State var alertMsg = ""
    var foodData = [MenuModel]()
    var offerPrice = Float()
    @State var menuOptionsArr = [[String:String]]()
    @StateObject var orderingData = OrderDetails()
    @State var extraPrice : Float = 0.00
    @State var menuItemOptionSelectedArr = [[String:String]]()
    @State var alradyAdded = false
    @State var menuItemOptionIndex: Int = 0
    
    
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    NavigationBarView()
                    FoodListViewItem(foodName: foodData[0].name, foodSubTitle: foodData[0].description, price: foodData[0].price!, offerPrice: offerPrice)
                        .frame(height: 112, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer().frame(height: 20)
                    Group{
                        HStack{
                            Spacer().frame(width:30)
                            Text("Extra Price")
                            Spacer()
                            Text("$\(extraPrice, specifier: "%.2f")")
                            Spacer().frame(width:30)
                            
                        }
                        Spacer().frame(height:18)
                        
                        Divider()
                            .background(Color.black)
                        ///horizontal view for categorys
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack{
                                ForEach(0..<(foodData[0].menuItemOptions.count), id: \.self){ index in
                                    
                                    if menuItemOptionIndex == index {
                                        CategoryListItem(buttonSelect: .constant(true), catText: (foodData[0].menuItemOptions[index].name))
                                            .onTapGesture(perform: {
                                                menuItemOptionIndex = index
                                            })
                                    }else{
                                        CategoryListItem(buttonSelect: .constant(false), catText: (foodData[0].menuItemOptions[index].name))
                                            .onTapGesture(perform: {
                                                menuItemOptionIndex = index
                                            })
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                        .frame(height: 30)
                        .padding(.horizontal, 10)
                    }
                    Group{
                        Divider()
                            .background(Color.black)
                        Spacer()
                        List{
                            if self.foodData[0].menuItemOptions.count > 0{
                                ForEach((self.foodData[0].menuItemOptions[menuItemOptionIndex].menuItemOptionValues)){ item in
                                    
                                    HStack{
                                        Text(item.name)
                                            .font(.custom("SourceSansPro-Regular", fixedSize: 14))
                                        Spacer()
                                        Text("$\(item.price!, specifier: "%.2f")")
                                            .font(.custom("SourceSansPro-Regular", fixedSize: 14))
                                        Spacer().frame(width: 30)
                                        Button(action: {
                                            let dict = ["name" : self.foodData[0].menuItemOptions[menuItemOptionIndex].name , "value" : item.name, "price" : String(item.price!)] as [String : String]
                                            if checkAlreadyAdd(name: item.name){
                                                self.extraPrice -= item.price!
                                                for i in 0..<(self.menuItemOptionSelectedArr.count) {
                                                    if self.menuItemOptionSelectedArr[i]["value"]! == item.name {
                                                        self.menuItemOptionSelectedArr.remove(at: i)
                                                        return
                                                    }
                                                }
                                            }else{
                                                self.menuItemOptionSelectedArr.append(dict)
                                                self.extraPrice += item.price!
                                            }
                                            print(self.menuItemOptionSelectedArr)
                                            
                                        }, label: {
                                            Text(checkAlreadyAdd(name: item.name) ? "Delete" : "Add")
                                                .font(.custom("SourceSansPro-Light", fixedSize: 14))
                                                .foregroundColor(checkAlreadyAdd(name: item.name) ?  Color.white : Color.appThemeMustured)
                                                .frame(width: 60, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                .background(checkAlreadyAdd(name: item.name) ?  Color.appThemeMustured : Color.white)
                                            
                                        })
                                        .frame(width: 60, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .overlay(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.appThemeMustured) )
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        Spacer().frame(width: 10)
                                        
                                    }
                                    .frame(height: 30)
                                    
                                }
                            }
                            
                        }
                        .background(Color.white)
                        .listStyle(PlainListStyle())
                        .environment(\.horizontalSizeClass, .regular)
                        .frame(height: 150)
                    }
                    Group{
                        Spacer().frame(height: 10)
                        Text("Quantity")
                            .font(.custom("SourceSansPro-Regular", fixedSize: 16))
                        Spacer().frame(height: 10)
                        TextField("0", text: $quantitlyTextVal)
                            .font(.custom("SourceSansPro-Regular", fixedSize: 30))
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.black)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        Spacer().frame(height: 10)
                    }
                    Group{
                        Button(action: {
                            self.endEditing(true)
                            if quantitlyTextVal == ""{
                                alertMsg = "Please Enter Quantity"
                                isShowAlertView.toggle()
                            }else if Int(quantitlyTextVal) == 0{
                                alertMsg = "Please Enter minimum 1 Quantity"
                                isShowAlertView.toggle()
                            }else{
                                addFoodToCart()
                            }
                        }, label: {
                            Text("Add to order")
                                .foregroundColor(.white)
                                .font(.custom("Quicksand-Bold", fixedSize: 25))
                                .frame(width: UIScreen.main.bounds.width-135, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        })
                        .background(Color.init("AppThemeMusturd"))
                        .cornerRadius(30)
                    }
                }
            }
            .modifier(YourOrderPopupView(isPresented: isShowOrderView, content: {
                Color.white.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height-200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }))
            
            VStack {
                HStack{
                    Spacer().frame(width: 12)
                    Image("upArrowIcons")
                        .rotationEffect(isShowOrderView ? .degrees(180) : .zero)
                    Spacer()
                    Text("YOUR ORDER")
                        .font(.custom("SourceSansPro-Regular", fixedSize: 26))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("upArrowIcons")
                        .rotationEffect(isShowOrderView ? .degrees(180) : .zero)
                    Spacer().frame(width: 12)
                    
                }
                .onTapGesture(perform: {
                    isShowOrderView.toggle()
                    
                })
                .frame(height: 72)
                .background(Color.init("AppThemeMusturd"))
                
            }
            .alert(isPresented: $isShowAlertView, title: "Alert", message: alertMsg)
            
        }
        .environmentObject(orderingData)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
    
    //MARK:- add food item to cart
    func addFoodToCart()
    {
        self.menuOptionsArr = menuItemOptionSelectedArr
        let data = foodData[0]
        var finalPrice : CGFloat
        var extraPrice : Float = 0.0
        var localID = 0
        
        ///add a local id so if same item repeat in model so model not be effected
        if globalOrderData.count > 0 {
            localID = globalOrderData[globalOrderData.count - 1].localId! + 1
        }
        
        for i in menuOptionsArr {
            let p = i["price"]!
            extraPrice += Float(p)!
        }
        ///if offer price is greater then zero then make final price with offer price , if not then use main price
        if offerPrice != 0{
            finalPrice = CGFloat(Float(quantitlyTextVal)! * (offerPrice + extraPrice))
        }else{
            finalPrice = CGFloat(Float(quantitlyTextVal)! * (data.price! + extraPrice))
        }
        let orderDataa = OrderModel.init(restaurantId: data.restaurantId!, menuItemId: data.menuItemId!, category: data.category!, name: data.name!, description: data.description ?? "", price: data.price!, createdDate: data.createdDate!, availableOptionsCount: 0, offerPrice: offerPrice, quantity: Int(quantitlyTextVal) ?? 1, finalPrice: finalPrice, orderItemOptions: menuOptionsArr, localId: localID)
        
        orderingData.orderData = globalOrderData
        var index = -1
        _ = true
        var checkForDiffRes = false
        for i in orderingData.orderData{
            index += 1
            if i.restaurantId != orderDataa.restaurantId {
                checkForDiffRes = true
            }
        }
        ///if user add food from different restaurant then other restaurant food removed from card and add new food
        if checkForDiffRes {
            orderingData.orderData.removeAll()
            orderingData.orderData.append(orderDataa)
        }else{
            orderingData.orderData.append(orderDataa)
        }
        globalOrderData = orderingData.orderData
        alertMsg = "Food added successfully"
        isShowAlertView.toggle()
    }
    
    func selectMenuItemOption(selectedOptions: [[String : String]]) {
        self.menuOptionsArr = selectedOptions
    }
    
    func checkAlreadyAdd(name : String) -> Bool
    {
        var check = false
        for i in self.menuItemOptionSelectedArr {
            if i["value"]! == name {
                check = true
                return check
            }
        }
        return check
    }
}

struct FoodOrderAddView_Previews: PreviewProvider {
    static var previews: some View {
        FoodOrderAddView()
        
    }
}

