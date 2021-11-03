//
//  CustomNavigationView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 13/07/21.
//

import SwiftUI

struct CustomNavigationView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isShowSideMenu = false
    @ObservedObject var userData = UserDataModel.shared
    @State var isHideBackButton = false
    @State var isHideProfileButton = false
    
    var body: some View {
        VStack{
        HStack(alignment: .center){
            
            Spacer().frame(width:16)
            
            if !isHideBackButton{
            VStack(alignment: .leading){
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Image("backIcon")
                })
                .frame(width: 35, height: 55, alignment: .leading)
            }
            }else{
                Spacer().frame(width:35)
            }
            
            Spacer()
            
            Text("bite")
                .font(.custom("Poppins-ExtraBold", fixedSize: 45))
                .foregroundColor(Color.init("AppThemeMusturd"))
            
            Spacer()
            
            if !isHideProfileButton{
            Button(action: {
                isShowSideMenu.toggle()
            }, label: {
                Image(uiImage: userData.data.profile_image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 38, height: 38)
            })
            }else{
                Spacer().frame(width:38)
            }
            NavigationLink(destination: SideMenuView(),isActive: $isShowSideMenu)
            {
            }
            
            Spacer().frame(width:12)
            
        }
        }
    }
}

struct CustomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationView()
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 80))
    }
}

struct NavigationBarView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isShowProfileView = false

    var body: some View {
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
                    isShowProfileView.toggle()
                }, label: {
                    Image("Info Icon")
                }).hidden()
                
                Spacer().frame(width:35)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Spacer().frame(height: 0)
            NavigationLink(
                destination: ProfileView(),
                isActive: $isShowProfileView){
                
            }
            
            Divider()
        }
        
    }
}
