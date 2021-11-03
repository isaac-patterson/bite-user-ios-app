import SwiftUI
import Amplify
import AWSPluginsCore
import Foundation

struct HomeView: View {
    
    @State var searchText = ""
    @State var isShowSideMenu: Bool = false
    @State var isShowMenuDetailView: Bool = false
    @ObservedObject var loginData = LoginUserModel.shared
    @ObservedObject var fetcher = RestaurantDataFetcher()
    @State var isShowAlert = false
    @State var alertMsg = ""
    @State var selectResData = [RestaurantModel]()
    @State var didAppear = false
    @State var appearCount = 0
    
    var body: some View {
        NavigationView{
            VStack{
                Group{
                    CustomNavigationView(isHideBackButton: true)
                        .frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(height: 0)
                    
                    Divider()
                    
                    Spacer().frame(height:0)
                    
                    SearchBarView(text: $searchText)
                        .onChange(of: searchText, perform: { value in
                            if value.count >= 3{
                                fetcher.resutrantSearchApi(searchTxt: value)
                            }else if value == ""{
                                fetcher.getResutrantList()
                                print("empty")
                            }
                        })
                    
                    Spacer().frame(height:5)
                }
                Group{
                    HStack{
                        Spacer().frame(width: 29)
                        Text("Buy again from Cafe Strata \nFlat White ☕")
                            .foregroundColor(.white)
                            .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                            .frame(height: 75)
                        
                        Spacer()
                        
                        Text("$3.50")
                            .foregroundColor(.white)
                            .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                        
                        Spacer().frame(width: 20)
                    }
                    .padding(.horizontal, 10)
                    .background(Color.init("AppGreen"))
                    .cornerRadius(20)
                    .frame(width: UIScreen.main.bounds.width-20,height: 0)
                    .hidden()
                    
                    Spacer().frame(height: 0)
                    
                    HStack {
                        Spacer().frame(width: 10)
                        Text("GRAB A BITE 😋")
                            .foregroundColor(.init(hex: "1479F2"))
                            .font(.custom("SourceSansPro-Bold", fixedSize: 25))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    Divider()
                }
                
                ///use fetcher class for get resturant data and list will show after data fetche
                List{
                    if fetcher.loading {
                        CircleLoader()
                    }
                    ForEach(fetcher.restaurantArr)
                    { item in
                        ZStack{
                            ListViewItem(titleText: item.name, subtitleText: item.address, logo: item.logoIcon, offer: item.offer ?? 0, restaurantData: item)
                                .onTapGesture {
                                    selectResData = [item]
                                    isShowMenuDetailView.toggle()
                                }
                                .listRowInsets(EdgeInsets())
                            ///check that restaurant is close or not, if its close then user saw the alert and the restaurant bg color is offwhite
                            if getRestaurantTime(restdata: item){
                                
                                Button {
                                } label: {
                                    EmptyView()
                                        .background(Color.gray.opacity(0.3))
                                        .onTapGesture {
                                            alertMsg = "Oh no, that store is currently closed 😴"
                                            isShowAlert.toggle()
                                        }
                                }
                            }else{
                                NavigationLink(destination: MenuLeadingView(restaurantDetail: selectResData).environmentObject(MenuDataFetcher()),isActive: $isShowMenuDetailView){}
                                    .hidden()
                            }
                        }
                        
                    }
                    
                }
                .environment(\.horizontalSizeClass, .regular)
                .listStyle(PlainListStyle())
                .alert(isPresented: $fetcher.isShowError, title: "Alert", message: "No restaurant found")
                .alert(isPresented: $isShowAlert, title: "Alert", message: alertMsg)
                
                
            }
            .onAppear(perform: {
                if !didAppear {
                    appearCount += 1
                    fetchAttributes()
                    downloadProfileImgData()
                }
                didAppear = true
            })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
        
    }
    
    //MARK:- get login user details
    func fetchAttributes() {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                print("User attributes - \(attributes)")
                for i in attributes {
                    let key = i.key.rawValue
                    let value = i.value
                    DispatchQueue.main.async {
                        if "name" == key {
                            UserDataModel.shared.data.name = value
                        }else if "phone_number_verified" == key {
                            UserDataModel.shared.data.phone_number_verified = Bool(value)
                        }else if "email_verified" == key {
                            UserDataModel.shared.data.email_verified = Bool(value)
                        }else if "email" == key {
                            UserDataModel.shared.data.email = value
                        }else if "sub" == key {
                            UserDataModel.shared.data.sub = value
                        }else if "preferred_username" == key {
                            UserDataModel.shared.data.preferredUsername = value
                        }else if "phone_number" == key {
                            UserDataModel.shared.data.phoneNumber = value
                        }else if "custom:last_name" == key {
                            UserDataModel.shared.data.last_name = value
                        }else if "custom:first_name" == key {
                            UserDataModel.shared.data.first_name = value
                        }else if "custom:birthDate" == key {
                            UserDataModel.shared.data.birthDate = value
                        }
                    }
                    
                }
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }
    }
    
    //MARK:- get login user profile photo and download
    func downloadProfileImgData() {
        if UserDataModel.shared.data.profile_image != UIImage(named: "ProfilePlaceholder_large"){
            return
        }
        let key = "\(LoginUserModel.shared.data.user_id ?? "")profilePhoto"
        let identityId = LoginUserModel.shared.data.user_id ?? ""
        
        let options = StorageDownloadDataRequest.Options(accessLevel: .protected, targetIdentityId: identityId)
        Amplify.Storage.downloadData(
            key: key,
            options: options,
            progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { (event) in
                switch event {
                case let .success(data):
                    print("Completed: \(data)")
                    DispatchQueue.main.async {
                        UserDataModel.shared.data.profile_image = UIImage(data: data)
                    }
                case let .failure(storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            })
    }
    
    func getRestaurantTime(restdata : RestaurantModel) -> Bool
    {
        let day = Date().dayOfWeek()
        let date = Date()
        let calendar = Calendar.current
        var showEmoji = false
        let hour = calendar.component(.hour, from: date)
        _ = calendar.component(.minute, from: date)
        _ = calendar.component(.second, from: date)
        
        var todayData : RestaurantOpenDaysModel?
        for i in restdata.restaurantOpenDays!
        {
            if day?.lowercased() == i.day.lowercased() {
                todayData = i
                break
            }
            
        }
        
        if !todayData!.isOpen {
            showEmoji = true
            return showEmoji
        }
        //&& (todayData?.closeTime.minutes)! < minutes
        //&& (todayData?.openTime.minutes)! > minutes
        if (todayData?.closeTime.hours)! <= hour  {
            showEmoji = true
            return showEmoji
        }else if (todayData?.openTime.hours)! >= hour {
            showEmoji = true
            return showEmoji
        }else{
            showEmoji = false
            return showEmoji
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//MARK:- restaurant list api fetcher class
/* call restaurant list api and add data to model, this class call when list is loading */
class RestaurantDataFetcher: ObservableObject {
    
    @Published var restaurantArr = [RestaurantModel]()
    @Published var loading = false
    @Published var isShowError = false
    
    init() {
        getSession()
    }
    
    func getResutrantList() {
        DispatchQueue.main.async {
            self.loading = true
        }
        let url = URL(string: "https://biteapp.work/user/api/restaurant/getAll/")!
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
                    let decodedLists = try JSONDecoder().decode(RestaurantModelData.self, from: d)
                    DispatchQueue.main.async {
                        print(decodedLists)
                        self.restaurantArr = decodedLists.data
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
    
    func resutrantSearchApi(searchTxt : String) {
        loading = true
        let search = searchTxt.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        let url = URL(string: "https://biteapp.work/user/api/Restaurant/getSearch/\(search)")!
        let headers = [
            "Authorization": "Bearer \(LoginUserModel.shared.data.idToken ?? "")"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                self.loading = false
                if let d = data {
                    
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if json["error"] != nil {
                            self.isShowError = true
                        }else{
                            let decodedLists = try JSONDecoder().decode(RestaurantModelData.self, from: d)
                            DispatchQueue.main.async {
                                print(decodedLists)
                                self.restaurantArr = decodedLists.data
                            }
                        }
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
    
    
    func getSession(){
        loading = true
        Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()
                DispatchQueue.main.async {
                    self.loading = false
                }
                // Get user sub or identity id
                if let identityProvider = session as? AuthCognitoIdentityProvider {
                    let usersub = try identityProvider.getUserSub().get()
                    let identityId = try identityProvider.getIdentityId().get()
                    print("User sub - \(usersub) and identity id \(identityId)")
                    DispatchQueue.main.async {
                        LoginUserModel.shared.data.user_id = identityId
                        LoginUserModel.shared.data.user_idWORegionStr = identityId.replacingOccurrences(of: "us-east-1:", with: "")         /// identity id of user
                    }
                }
                
                // Get aws credentials
                if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
                    let credentials = try awsCredentialsProvider.getAWSCredentials().get()
                    print("Access key - \(credentials.accessKey) ")         ///user access key
                }
                
                // Get cognito user pool token
                if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    print("Id token - \(tokens.idToken) ")
                    DispatchQueue.main.async {
                        LoginUserModel.shared.data.idToken = tokens.idToken         /// id token and save to login model
                        LoginUserModel.shared.data.accessToken = tokens.accessToken    ///access token
                        LoginUserModel.shared.data.refreshToken = tokens.refreshToken       ///refresh token
                        self.getResutrantList()
                    }
                    
                }
                
            } catch {
                self.loading = false
                print("Fetch auth session failed with error - \(error)")
            }
        }
        
        
    }
    
}


//MARK:- list view item/cell
struct ListViewItem: View {
    
    var titleText: String
    var subtitleText: String
    var logo: String
    var offer: Float
    @State var bgColor: Color = .white
    var restaurantData: RestaurantModel
    @State var showSleepEmoji = false
    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                Spacer().frame(width:0)
                if logo == ""{
                    Image("defaultplaceholder")
                        .resizable()
                        .frame(width: 43, height: 39, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }else{
                    Text(logo.decodingUnicodeCharacters)
                        .font(.custom("Quicksand-Bold", size: 40))
                        .frame(width: 43, height: 39)
                }
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Text(titleText)
                        .font(.custom("SourceSansPro-Bold", fixedSize: 14))
                        .multilineTextAlignment(.leading)
                    Text(subtitleText)
                        .font(.custom("SourceSansPro-Italic", fixedSize: 14))
                    
                }
                Spacer()
                if showSleepEmoji{
                    Text("😴")
                        .font(.custom("Quicksand-Bold", size: 30))
                }else{
                    VStack(alignment: .trailing) {
                        if offer == 0{
                            Text("")
                                .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.init(red: 151/255, green: 210/255, blue: 242/255))
                            
                        }else{
                            Text("\((offer * 100), specifier: "%.2f")% off on items")
                                .font(.custom("SourceSansPro-Bold", fixedSize: 15))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .frame(width: 80)
                                .foregroundColor(Color.init(red: 151/255, green: 210/255, blue: 242/255))
                            
                        }
                        
                    }
                    .padding(5)
                }
                Spacer().frame(width: 0)
            }
        }
        .onAppear(perform: {
            self.showSleepEmoji = setRestaurantTime()
        })
        //.background(bgColor)
    }
    
    func setRestaurantTime() -> Bool
    {
        let day = Date().dayOfWeek()
        let date = Date()
        let calendar = Calendar.current
        var showEmoji = false
        let hour = calendar.component(.hour, from: date)
        _ = calendar.component(.minute, from: date)
        _ = calendar.component(.second, from: date)
        
        var todayData : RestaurantOpenDaysModel?
        for i in restaurantData.restaurantOpenDays!
        {
            if day?.lowercased() == i.day.lowercased() {
                todayData = i
                break
            }
        }
        
        if !todayData!.isOpen {
            self.bgColor = .offWhite
            showEmoji = true
            return showEmoji
        }
        
        if (todayData?.closeTime.hours)! <= hour  {
            showEmoji = true
            return showEmoji
        }else if (todayData?.openTime.hours)! >= hour {
            showEmoji = true
            return showEmoji
        }else{
            showEmoji = false
            return showEmoji
        }
        
    }
}

//struct ListViewItem_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ListViewItem(titleText: "test", subtitleText: "test", logo: "U+1F359", offer: 0, restaurantData: nil)
//            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 75))
//    }
//}
