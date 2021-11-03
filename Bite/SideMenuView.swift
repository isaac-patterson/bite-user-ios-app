//
//  SideMenuView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 13/07/21.
//

import SwiftUI
import Amplify
import Stripe

struct SideMenuView: View, SelectCardDetailDelegate {
    func selectCard(cardPara: STPPaymentMethodCardParams, isCardSave: Bool?, savedCardData: CardDetailModel?) {
        
    }
    
    var profileMenuIconArr = ["ReceiptsIcons","ReceiptsIcons","paymenticon","profileIcon"]
    var profileMenuTitleArr = ["Current Orders","Past Orders","Payment","Profile"]
    var infoMenuTitleArr = ["User Agreement","Contact Us"]
    var infoMenuIconArr = ["userAgermentIcon","contactusIcon"]
    
    @State var isShowProfileView = false
    @State var isShowPaymentView = false
    @State var isShowUserAgrementView = false
    @State var isShowContactUsView = false
    @State var isShowLoginView = false
    @State var goBackView = false
    @State var isShowRecieptView = false
    @State var loading = false
    @State var orderListType = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var userData = UserDataModel.shared
    
    
    var body: some View {
        ScrollView{
            VStack{
                ////custimze navigation bar view
                NavigationBarView()
                Spacer().frame(height:33)
                
                HStack {
                    Spacer().frame(width: 28)
                    
                    Image(uiImage: userData.data.profile_image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 65, height: 65)
                    
                    Spacer().frame(width:21)
                    
                    VStack(alignment: .leading) {
                        Text(userData.data.name)
                            .font(.custom("SourceSansPro-SemiBold", size: 24))
                        
                        Text(userData.data.preferredUsername)
                            .font(.custom("SourceSansPro-LightItalic", size: 14))
                        
                    }
                    
                    Spacer()
                }
                
                Spacer().frame(height:38)
                Group{
                    HStack {
                        Spacer().frame(width: 60)
                        Text("Profile")
                            .font(.custom("SourceSansPro-SemiBold", size: 24))
                        Spacer()
                    }
                    Spacer().frame(height: 5)
                    
                    ScrollView{
                        LazyVStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0){
                            ForEach(0..<profileMenuTitleArr.count){ index in
                                
                                MenuOptionView(iconName: profileMenuIconArr[index], titleName: profileMenuTitleArr[index])
                                    .padding(.init(top: 0, leading: 32, bottom: 0, trailing: 32))
                                    .frame(height:60)
                                    .onTapGesture(perform: {
                                        if index == 0{
                                            orderListType = "current"
                                            isShowRecieptView.toggle()
                                        }else if index == 1{
                                            orderListType = "past"
                                            isShowRecieptView.toggle()
                                        }else if index == 2{
                                            isShowPaymentView.toggle()
                                        }else{
                                            isShowProfileView.toggle()
                                        }
                                    })
                                
                            }
                        }
                    }
                    if isShowPaymentView {
                        NavigationLink(
                            destination: PaymentMethodsView(from: "Payment", delegate: self, rootisActive: .constant(true)),isActive: $isShowPaymentView){
                            
                        }
                    }
                    
                    NavigationLink(
                        destination: ProfileView(), isActive: $isShowProfileView){
                        
                    }
                    
                    if isShowRecieptView{
                        NavigationLink(
                            destination: ReceiptView(orderType: orderListType).environmentObject(OrderFetch()), isActive: $isShowRecieptView){
                            
                        }
                    }
                    
                    Group{
                        Spacer().frame(height: 30)
                        HStack {
                            Spacer().frame(width: 60)
                            Text("Information")
                                .font(.custom("SourceSansPro-SemiBold", size: 24))
                            Spacer()
                        }
                        Spacer().frame(height: 5)
                        
                        LazyVStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0, pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/){
                            ForEach(0..<infoMenuTitleArr.count){ index in
                                
                                MenuOptionView(iconName: infoMenuIconArr[index], titleName: infoMenuTitleArr[index])
                                    .padding(.init(top: 0, leading: 32, bottom: 0, trailing: 32))
                                    .frame(height:60)
                                    .onTapGesture(perform: {
                                        if index == 0{
                                            isShowUserAgrementView.toggle()
                                        }else{
                                            isShowContactUsView.toggle()
                                        }
                                    })
                                
                            }
                        }
                        
                        NavigationLink(
                            destination: UserAgrementView(),isActive: $isShowUserAgrementView){
                            
                        }
                        
                        NavigationLink(
                            destination: ContactUsView(), isActive: $isShowContactUsView){
                            
                        }
                        Spacer().frame(height: 11)
                        
                        Button(action: {
                            signOutLocally()
                            loading.toggle()
                        }, label: {
                            if loading {
                                CircleLoader()
                                    .foregroundColor(Color.init("AppThemeMusturd"))
                                    .frame(width: 202, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                            }else{
                                Text("Log me out")
                                    .font(.custom("SourceSansPro-Light", fixedSize: 24))
                                    .foregroundColor(Color.init("AppThemeMusturd"))
                                    .frame(width: 202, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            }
                            
                        })
                        .overlay(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .stroke(Color.init("AppThemeMusturd")) )
                        
                        NavigationLink(
                            destination: SignInView(), isActive: $isShowLoginView){
                            
                        }
                        Spacer().frame(height: 100)
                    }
                    
                }
                
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 0)
    }
    
    //MARK:- sign out user from amplify
    func signOutLocally() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                loading.toggle()
                UserDataModel.shared.data.profile_image = UIImage(named: "ProfilePlaceholder_large")
                UserDataModel.shared.data.name = ""
                UserDataModel.shared.data.last_name = ""
                UserDataModel.shared.data.email = ""
                UserDataModel.shared.data.phoneNumber = ""
                UserDataModel.shared.data.preferredUsername = ""
                UserDataModel.shared.data.sub = ""
                
                LoginUserModel.shared.data.user_id = ""
                LoginUserModel.shared.data.idToken = ""
                LoginUserModel.shared.data.accessToken = ""
                LoginUserModel.shared.data.user_idWORegionStr = ""
                LoginUserModel.shared.data.refreshToken = ""
                print("Successfully signed out")
                
                isShowLoginView.toggle()
            case .failure(let error):
                loading.toggle()
                print("Sign out failed with error \(error)")
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}

//MARK:- side menu child view
struct MenuOptionView: View {
    
    var iconName: String
    var titleName: String
    
    var body: some View{
        VStack{
            HStack{
                Spacer().frame(width: 18)
                
                Image(iconName)
                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(width: 21)
                
                Text(titleName)
                    .font(.custom("SourceSansPro-Light", size: 16))
                
                Spacer()
                
                Image("rightArrowIcon")
                
                Spacer().frame(width: 5)
            }
        }
    }
}

struct MenuOptionView_Previews: PreviewProvider {
    static var previews: some View {
        MenuOptionView(iconName: "", titleName: "")
            .previewLayout(.fixed(width: 310, height: 60))
        
    }
}

