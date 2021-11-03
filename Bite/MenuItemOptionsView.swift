//
//  MenuItemOptionsView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 26/08/21.
//

import SwiftUI

protocol MenuItemOptionDelegate {
    func selectMenuItemOption(selectedOptions: [[String:String]])
}

struct MenuItemOptionsView: View {
    
    @State var menuItemData : MenuModel?
    @State var menuItemOptionIndex: Int = 0
    var offerPrice = Float()
    @State var extraPrice : Float = 0.00
    @State var menuItemOptionSelectedArr = [[String:String]]()
    @State var alradyAdded = false
    var delegate: MenuItemOptionDelegate
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var navigation: some View {
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
                    .font(.custom("Poppins-ExtraBold", fixedSize: 45))
                    .foregroundColor(Color.init("AppThemeMusturd"))
                
                Spacer()
                
                Button(action: {
                    delegate.selectMenuItemOption(selectedOptions: menuItemOptionSelectedArr)
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                        .font(.custom("SourceSansPro-Bold", fixedSize: 20))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                })
                
                Spacer().frame(width:12)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: 80, alignment: .center
            )
            Spacer().frame(height: 0)
            
            
            Divider()
        }
        
    }
    
    
    var body: some View {
        VStack{
            navigation
            FoodListViewItem(foodName: menuItemData?.name, foodSubTitle: menuItemData?.description, price: (menuItemData?.price)!, offerPrice: offerPrice)
                .frame(height: 112, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Spacer().frame(height:18)
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
                    ForEach(0..<(menuItemData?.menuItemOptions.count)!, id: \.self){ index in
                        
                        if menuItemOptionIndex == index {
                            CategoryListItem(buttonSelect: .constant(true), catText: (menuItemData?.menuItemOptions[index].name)!)
                                .onTapGesture(perform: {
                                    menuItemOptionIndex = index
                                })
                        }else{
                            CategoryListItem(buttonSelect: .constant(false), catText: (menuItemData?.menuItemOptions[index].name)!)
                                .onTapGesture(perform: {
                                    menuItemOptionIndex = index
                                })
                            
                        }
                        
                    }
                    
                }
            }
            .frame(height: 30)
            .padding(.horizontal, 10)
            Divider()
                .background(Color.black)
            Spacer()
            List{
                if self.menuItemData?.menuItemOptions.count ?? 0 > 0{
                ForEach((self.menuItemData?.menuItemOptions[menuItemOptionIndex].menuItemOptionValues)!){ item in
                    
                    HStack{
                        Text(item.name)
                        Spacer()
                        Text("$\(item.price!, specifier: "%.2f")")
                        Spacer().frame(width: 30)
                        Button(action: {
                            let dict = ["name" : self.menuItemData?.menuItemOptions[menuItemOptionIndex].name ?? "", "value" : item.name, "price" : String(item.price!)] as [String : String]
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
                                .font(.custom("SourceSansPro-Light", fixedSize: 16))
                                .foregroundColor(checkAlreadyAdd(name: item.name) ?  Color.white : Color.appThemeMustured)
                                .frame(width: 60, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(checkAlreadyAdd(name: item.name) ?  Color.appThemeMustured : Color.white)
                            
                        })
                        .frame(width: 60, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.appThemeMustured) )
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer().frame(width: 10)
                        
                    }
                    .frame(height: 50)
                    
                }
                }
                
            }
            .background(Color.white)
            .listStyle(PlainListStyle())
            .environment(\.horizontalSizeClass, .regular)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
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

//struct MenuItemOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuItemOptionsView(delegate: <#MenuItemOptionDelegate#>)
//    }
//}
