//
//  ProfileView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 16/07/21.
//

import SwiftUI
import Introspect
import Amplify
import AWSPluginsCore
import AWSS3StoragePlugin
import AWSAuthCore
import AWSS3

struct ProfileView: View {
    
    var profileDetailArr = [UserDataModel.shared.data.first_name,UserDataModel.shared.data.last_name,UserDataModel.shared.data.birthDate,UserDataModel.shared.data.email,"******"]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var uiTabarController: UITabBarController?
    @State private var profileImage: Image? = Image(uiImage: UserDataModel.shared.data.profile_image)
    @State var profileuiImage: UIImage?
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State var loading = false
    @State var isShowAlertView = false
    @State var alertMsg = ""
    @ObservedObject var userData = UserDataModel.shared
    
    var body: some View {
        NavigationView{
            VStack{
                Group{
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
                        
                        
                        Spacer().frame(width:10)
                        
                        Text("edit account")
                            .font(.custom("Quicksand-Bold", fixedSize: 30))
                            .foregroundColor(Color.init("AppThemeMusturd"))
                        
                        Spacer()
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer().frame(height: 0)
                    Divider()
                    Spacer().frame(height: 70)
                    HStack {
                        Spacer().frame(width:50)
                        ZStack{
                            
                            Image(uiImage: userData.data.profile_image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 65, height: 65)
                                .onTapGesture { self.shouldPresentActionScheet = true }
                                .sheet(isPresented: $shouldPresentImagePicker) {
                                    ImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$profileImage, uiimage: self.$profileuiImage ,isPresented: self.$shouldPresentImagePicker)
                                }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                                    ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                        self.shouldPresentImagePicker = true
                                        self.shouldPresentCamera = true
                                    }), ActionSheet.Button.default(Text("Photo Library"), action: {
                                        self.shouldPresentImagePicker = true
                                        self.shouldPresentCamera = false
                                    }), ActionSheet.Button.cancel()])
                                }
                                .onChange(of: profileImage) { newvalue in
                                    uploadProfileImage()
                                }
                            if loading{
                                CircleLoader()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .background(Color.clear)
                            }
                        }
                        Spacer()
                    }
                    Spacer().frame(height: 60)
                }
                List{
                    ForEach(0..<profileDetailArr.count){ index in
                        ZStack{
                            if index == 0{
                                NavigationLink(destination: EditFirstNameView(firstNameText: userData.data.first_name!)){
                                }.hidden()
                                ProfileDataListItemView(text: userData.data.first_name)
                                    .listRowInsets(EdgeInsets())
                                    .frame(height:60)
                            }else if index == 1{
                                NavigationLink(destination: EditLastNameView(lastNameText: userData.data.last_name!)){
                                }.hidden()
                                ProfileDataListItemView(text: userData.data.last_name)
                                    .listRowInsets(EdgeInsets())
                                    .frame(height:60)
                            }else if index == 2{
                                NavigationLink(destination: EditBirthDateView(birthdateText: userData.data.birthDate!)){
                                }.hidden()
                                ProfileDataListItemView(text: userData.data.birthDate)
                                    .listRowInsets(EdgeInsets())
                                    .frame(height:60)
                            }else if index == 3{
                                //                                    NavigationLink(destination: EditEmailView(emailText: profileDetailArr[index]!)){
                                //                                    }.hidden()
                                ProfileDataListItemView(text: userData.data.email)
                                    .listRowInsets(EdgeInsets())
                                    .frame(height:60)
                                
                            }else{
                                NavigationLink(destination: EditPasswordView()){
                                }.hidden()
                                ProfileDataListItemView(text: "*********")
                                    .listRowInsets(EdgeInsets())
                                    .frame(height:60)
                                
                            }
                            
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertMsg)
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
    
    
    func uploadProfileImage() {
        loading = true
        let key = "\(LoginUserModel.shared.data.user_id ?? "")profilePhoto"
        
        guard let data = profileuiImage!.jpegData(compressionQuality: 0.5) else { return }
        
        let options = StorageUploadDataRequest.Options(accessLevel: .protected)
        Amplify.Storage.uploadData(key: key, data: data, options: options) { progress in
            print("Progress: \(progress)")
        } resultListener: { event in
            switch event {
            case .success(let data):
                print("Completed: \(data)")
                UserDataModel.shared.data.profile_image = profileuiImage
                loading = false
                alertMsg = "Profile Photo upload successfully."
                isShowAlertView.toggle()
            case .failure(let storageError):
                loading = false
                alertMsg = storageError.localizedDescription
                isShowAlertView.toggle()
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct ProfileDataListItemView: View {
    var text: String
    
    var body: some View{
        VStack{
            HStack{
                Spacer().frame(width: 54)
                
                if text == ""{
                    Text("Please Enter")
                        .font(.custom("Quicksand-Medium", size: 16))
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                }else{
                    Text(text)
                        .font(.custom("Quicksand-Medium", size: 16))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                
                Spacer()
                
                Image("rightArrowIcon")
                
                Spacer().frame(width: 20)
            }
        }
    }
}

struct ProfileDataListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDataListItemView(text: "Vincent")
            .previewLayout(.fixed(width: 310, height: 60))
        
    }
}
