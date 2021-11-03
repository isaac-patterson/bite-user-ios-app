//
//  MenuLeadingView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 14/07/21.
//

import SwiftUI
import Introspect

struct MenuLeadingView: View {
    
    @State var categorySelectIndex = 0
    @State var isSelectCategory = true
    @State var isUnSelectCategory = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isShowOrderView = false
    @EnvironmentObject private var menuFetcher : MenuDataFetcher
    @State private var filteredList = [MenuModel]()
    @State var categoryName: String = ""
    @State var uiTabarController: UITabBarController?
    var restaurantDetail = [RestaurantModel]()


    var body: some View {
        VStack{
            //ScrollView{
                VStack{
                    NavigationBarView()
                    Spacer().frame(height:20)
                    Group {
                        VStack(alignment:.leading){
                            Spacer().frame(height:20)
                            HStack(alignment: .top) {
                                Spacer().frame(width: 16)
                                VStack(alignment:.leading){
                                    Text(restaurantDetail[0].name)
                                        .font(.custom("SourceSansPro-Bold", fixedSize: 20))
                                        .multilineTextAlignment(.leading)
                                    Text(restaurantDetail[0].address)
                                        .font(.custom("SourceSansPro-Italic", fixedSize: 20))
                                    
                                }
                                
                                Spacer()
                                if restaurantDetail[0].logoIcon == ""{
                                    Image("defaultplaceholder")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }else{
                                    Text(restaurantDetail[0].logoIcon.decodingUnicodeCharacters)
                                        .font(.custom("Quicksand-Bold", size: 40))
                                        .frame(width: 40, height: 40)
                                    
                                }
                                Spacer().frame(width:12)
                            }
                            //                            let openingTime = convertDateFormatter(date: restaurantDetail[0].openingHour)
                            //                            let closeingTime = convertDateFormatter(date: restaurantDetail[0].closingHour)
                            Text("open now: \(getRestaurantTime())")
                                .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 16)
                            
                            LazyVStack(alignment: .leading) {
                                ForEach(0..<1)
                                {
                                    index in
                                    if restaurantDetail[0].offer != 0{
                                        Text("\((restaurantDetail[0].offer ?? 0) * 100, specifier: "%.2f")% off on all items")
                                        .font(.custom("SourceSansPro-Bold", fixedSize: 16))
                                        .foregroundColor(Color.init("AppThemeMusturd"))
                                        .multilineTextAlignment(.leading)
                                        .padding(.leading, 16)
                                    }
                                }
                            }
                        }
                        
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.init("AppThemeMusturd")) )
                    .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 22))
                    Spacer().frame(height:18)
                    Divider()
                        .background(Color.black)

                    ///horizontal view for categorys
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack{
                            ForEach(0..<menuFetcher.categoryArr.count, id: \.self){ index in
                                if categorySelectIndex == index{
                                    CategoryListItem(buttonSelect: $isSelectCategory, catText: menuFetcher.categoryArr[index])
                                        .onTapGesture(perform: {
                                            self.categoryName = menuFetcher.categoryArr[index]
                                            self.categorySelectIndex = index
                                        })
                                        .onAppear(perform: {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                                if index == 0{
                                                    self.categoryName = menuFetcher.categoryArr[index]
                                                    self.categorySelectIndex = index
                                                    self.filteredList = self.menuFetcher.menuArr.filter{$0.category == self.categoryName}

                                                }
                                                
                                                
                                            })
                                            
                                        })
                                        .onReceive(menuFetcher.$menuArr, perform: { _ in
                                            self.filteredList = self.menuFetcher.menuArr.filter{$0.category == self.categoryName}
                                        })
                                }else{
                                    CategoryListItem(buttonSelect: $isUnSelectCategory, catText: menuFetcher.categoryArr[index])
                                        .onTapGesture(perform: {
                                            self.categoryName = menuFetcher.categoryArr[index]
                                            self.categorySelectIndex = index
                                        })
                                        .onReceive(menuFetcher.$menuArr, perform: { _ in
                                            self.filteredList = self.menuFetcher.menuArr.filter{$0.category == self.categoryName}
                                        })
                                }
                                
                            }
                            
                        }
                    }
                    .frame(height: 30)
                    .padding(.horizontal, 10)
                    Divider()
                        .background(Color.black)
                    Spacer().frame(height:0)
                    ///food list view for perticular category
                    List{
                        if categoryName == ""{
                            CircleLoader()
                        }
                        ForEach(self.menuFetcher.menuArr.filter{$0.category == self.categoryName}){ item in
                            ZStack {
                                NavigationLink(destination: FoodOrderAddView(foodData: [item], offerPrice: getOfferPriceForItem(price: item.price!))){
                                }.hidden()
                                FoodListViewItem(foodName: item.name, foodSubTitle: item.description, price: item.price!, offerPrice: getOfferPriceForItem(price: item.price!))
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                        
                        
                    }
                    .background(Color.white)
                    .onReceive(menuFetcher.$menuArr, perform: { _ in
                        if menuFetcher.categoryArr.count > 0{
                            //self.categoryName = menuFetcher.categoryArr[0]
                            self.filteredList = self.menuFetcher.menuArr.filter{$0.category == self.categoryName}
                        }
                    })
                    .listStyle(PlainListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                }
            //}
            .modifier(YourOrderPopupView(isPresented: isShowOrderView, content: {
                Color.white.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height-200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }))///cart pop view
            ///bottom your order view
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
            
        }
        .onAppear(perform: {
            UITableViewCell.appearance().selectionStyle = .none
            menuFetcher.resId = restaurantDetail[0].restaurantId
            menuFetcher.getMenuData()
            
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
    ///convert date format to desiger time format
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
    //MARK:- get offer price for item
    ///get offer percentage and less that offer from main item price
    func getOfferPriceForItem(price : Float) -> Float {
        var offerPrice : Float = 0
        if restaurantDetail[0].offer ?? 0 > 0 {
            let discountP = Float(price) * Float(restaurantDetail[0].offer ?? 0)
            offerPrice = Float(price) - Float(discountP)
        }
        let op = String(format: "%.2f", offerPrice)
        return Float(op)!
    }
    
    ///get restaurant open close time acording current day
    func getRestaurantTime() -> String
    {
        let day = Date().dayOfWeek()
        let date = Date()
        let calendar = Calendar.current
        var resOpenCloseTime = ""
        _ = calendar.component(.hour, from: date)
        _ = calendar.component(.minute, from: date)
        _ = calendar.component(.second, from: date)
        
        var todayData : RestaurantOpenDaysModel?
        for i in restaurantDetail[0].restaurantOpenDays!
        {
            if day?.lowercased() == i.day.lowercased() {
                todayData = i
                let openTime = String(i.openTime.hours ?? 0) + ":" + String(i.openTime.minutes ?? 0)
                let closeTime = String(i.closeTime.hours ?? 0) + ":" + String(i.closeTime.minutes ?? 0)
                resOpenCloseTime = openTime + " - " + closeTime
                break
            }
        }
        
        if !todayData!.isOpen {
            return resOpenCloseTime
        }
        
        return resOpenCloseTime
        
    }
}

struct MenuLeadingView_Previews: PreviewProvider {
    static var previews: some View {
        MenuLeadingView()
            .environmentObject(MenuDataFetcher())
    }
}

struct CategoryListItem: View {
    
    @Binding var buttonSelect: Bool
    var catText: String
    
    var body: some View{
        Text(catText)
            .font(.custom("SourceSansPro-Regular", fixedSize: 14))
            .foregroundColor(buttonSelect ? .white : .black)
            .multilineTextAlignment(.leading)
            .frame(height: 25)
            .padding(.init(top: 1, leading: 15, bottom: 1, trailing: 15))
            .background(buttonSelect ? Color.init("AppThemeMusturd") : .white)
            .cornerRadius(20)
        
    }
}

//struct CategoryListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryListItem(buttonSelect: true, catText: "Appetizes")
//            .previewLayout(.fixed(width: 125, height: 30))
//    }
//}
//MARK:- menu item list sub view
struct FoodListViewItem: View {
    
    var foodName: String?
    var foodSubTitle: String?
    var price: Float
    var offerPrice: Float
    
    var body: some View {
        VStack{
            HStack(alignment:.top){
                Spacer().frame(width:29)
                VStack(alignment:.leading) {
                    Text(foodName!)
                        .font(.custom("SourceSansPro-Regular", fixedSize: 20))
                    Text(foodSubTitle ?? "")
                        .font(.custom("SourceSansPro-Italic", fixedSize: 16))
                        .foregroundColor(Color.init(hex: "9999A1"))
                }
                Spacer()
                VStack(alignment:.trailing){
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {

                        Text("$\(price, specifier: "%.2f")")
                            .font(.custom("SourceSansPro-Regular", fixedSize: 20))
                        if offerPrice != 0{
                            Divider()
                                .background(Color.black)
                                .frame(width: 50,height:3)
                        }
                        
                    }
                    Spacer().frame(height:1)
                    if offerPrice != 0{
                        Text("$\(offerPrice, specifier: "%.2f")")
                            .font(.custom("SourceSansPro-Regular", fixedSize: 20))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                    }
                    
                    
                }
                Spacer().frame(width: 34)
            }
        }
    }
}

struct FoodListViewItem_Previews: PreviewProvider {
    static var previews: some View{
        FoodListViewItem(foodName: "Kimchi salad", foodSubTitle: "", price: 0, offerPrice: 0)
            .previewLayout(.fixed(width: UIScreen.main.bounds.size.width, height: 112))
    }
}
//MARK:- Api call for menu list
class MenuDataFetcher: ObservableObject {
    
    @Published var menuArr : [MenuModel] = []
    @Published var categoryArr : [String] = []
    @Published var resId : String = ""
    @Published var loader = false
    
    func getMenuData() {
        if resId == "" {
            return
        }
        loader = true
        let url = URL(string: "https://biteapp.work/user/api/menu/getByRestaurantId/\(resId)")!
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                
                if let d = data {
                    DispatchQueue.main.async {
                        self.loader = false
                    }
                    if (try? JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]) != nil {
                    }
                    let decodedLists = try JSONDecoder().decode([MenuModel].self, from: d)
                    DispatchQueue.main.async {
                        print(decodedLists)
                        self.menuArr = decodedLists
                        ///get the all categorys list
                        var arr = [String]()
                        for i in self.menuArr{
                            if arr.count > 0 {
                                var check = false
                                for j in arr {
                                    if j != i.category{
                                        check = true
                                    }else{
                                        check = false
                                    }
                                }
                                if check {
                                    arr.append(i.category!)
                                }
                            }else{
                                arr.append(i.category!)
                            }
                        }
                        self.categoryArr = arr
                        print("Category array filted:--- \(arr)")
                    }
                }else {
                    self.loader = false
                    print("No Data")
                }
            } catch let parsingError {
                self.loader = false
                print ("Error", parsingError)
            }
            
        }.resume()
        loader = false
    }
    
}
