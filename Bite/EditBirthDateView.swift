//
//  EditBithDateView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 20/09/21.
//

import SwiftUI
import Amplify
import AWSPluginsCore

struct EditBirthDateView: View {
    
    @State var birthdateText = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""
    @State var showDatePicker = false
    @State var date = Date()
    @State var popoverSize = CGSize(width: 320, height: 300)
    let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Spacer().frame(width:18)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }, label: {
                        Image("CloseIcon")
                    })
                    Spacer()
                }
                Spacer().frame(height:143)
                HStack{
                    Spacer().frame(width:18)
                    VStack(alignment: .leading){
                        Text("Birth Date")
                            .foregroundColor(Color.init(hex: "9999A1"))
                            .font(.custom("Quicksand-Medium", size: 16))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        
                        WithPopover(showPopover: $showDatePicker, popoverSize: popoverSize) {
                            
                            VStack{
                                TextField("Bithdate", text: $birthdateText)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .font(.custom("Quicksand-Regular", size: 25))
                                    .frame(height:45)
                                    .background(Color.init(.sRGB, red: 242/255, green: 134/255, blue: 39/255, opacity: 0.65))
                                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            }
                            .background(Color.white)
                            .onTapGesture {
                                self.showDatePicker.toggle()
                            }
                            
                            
                            
                        } popoverContent: {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding(.bottom, -40)
                        }
                        
                        .onChange(of: date, perform: { value in
                            self.birthdateText = dateformatter.string(from: date)
                        })
                        
                        
                    }
                    Spacer().frame(width:18)
                }
                Spacer().frame(height:380)
                Button(action: {
                    if birthdateText == ""{
                        alertViewMsg = "Please select birthdate."
                        isShowAlertView.toggle()
                    }else{
                        updateAttribute()
                    }
                }, label: {
                    Text("Update birthdate")
                        .foregroundColor(.black)
                        .font(.custom("Quicksand-Bold", size: 20))
                        .frame(width: UIScreen.main.bounds.width-36, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                })
                .background(Color.init(.sRGB, red: 242/255, green: 134/255, blue: 39/255, opacity: 0.65))
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
        
    }
    
    //MARK:- update Name in Amplify
    func updateAttribute() {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.custom("birthDate"), value: birthdateText)) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    UserDataModel.shared.data.birthDate = birthdateText
                    alertViewMsg = "BirthDate update successfully"
                    isShowAlertView.toggle()
                    print("Update completed")
                }
            } catch {
                print("Update attribute failed with error \(error)")
            }
        }
    }
}

struct EditBirthDateView_Previews: PreviewProvider {
    static var previews: some View {
        EditBirthDateView()
    }
}
