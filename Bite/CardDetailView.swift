//
//  CardDetailView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 02/08/21.
//

import SwiftUI
import Stripe
import Introspect

protocol CardDetailDelegate {
    func sendCardParams(cardPara: STPPaymentMethodCardParams, response: CardDetailModel?, isCardSave: Bool?)
}

struct CardDetailView: View {
    
    @State var stripeCardParams = STPPaymentMethodCardParams()
    @State var buttonSelect = false
    @State var loading = false
    @State var isShowAlertView = false
    @State var alertMsg = ""
    var onlySave = false
    @State var isSaveCardforFuture = false
    var delegate: CardDetailDelegate
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var shouldPopToRootView : Bool
    @Environment(\.presentationMode) var dismiss

    var body: some View {
            VStack{
                Group{
                    CustomNavigationView()
                    Spacer().frame(height:0)
                    Divider()
                }
                StripePaymentCardTextField(cardParams: $stripeCardParams, isValid: .constant(true))
                    .frame(height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.horizontal, 15)
                    
                Spacer().frame(height: 10)
                    HStack {
                        Spacer().frame(width:20)
                        Text("Protected by stripe")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }

                Spacer().frame(height: 20)
                HStack{
                    
                    if !onlySave {
                        Spacer().frame(width:20)
                        Button(action: {
                            buttonSelect.toggle()
                            isSaveCardforFuture.toggle()
                        }, label: {
                            Image(systemName: buttonSelect ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(.black)
                        })
                        .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("save card details for future use.")
                            .foregroundColor(Color.init("AppThemeMusturd"))
                        Spacer()
                    }
                    
                }
                Spacer().frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    print("done pressed! \(stripeCardParams)")
                    if onlySave{
                        if stripeCardParams.number == nil || stripeCardParams.cvc == nil || stripeCardParams.expMonth == nil || stripeCardParams.expYear == nil {
                            
                        }else{
                            saveCard()
                        }
                    }else{
                        if stripeCardParams.number == nil || stripeCardParams.cvc == nil || stripeCardParams.expMonth == nil || stripeCardParams.expYear == nil {
                            
                        }else{
                            delegate.sendCardParams(cardPara: stripeCardParams, response: nil, isCardSave: isSaveCardforFuture)
                            self.shouldPopToRootView = false
                            dismiss.wrappedValue.dismiss()
                        }

                    }
                }, label: {
                    if onlySave{
                        Text("Save")
                            .foregroundColor(.white)
                            .font(.custom("SourceSansPro-Bold", fixedSize: 18))
                            .frame(width: UIScreen.main.bounds.width-250, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    }else{
                        Text("Done")
                            .foregroundColor(.white)
                            .font(.custom("SourceSansPro-Bold", fixedSize: 18))
                            .frame(width: UIScreen.main.bounds.width-250, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    }
                    
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(30)
                
                Spacer()
                
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertMsg)

                if loading {
                    CircleLoader()
                }
                

            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)


    }
    //MARK:- save card details
    func saveCard() {
        loading = true
        let parameters = ["senderCognitoId" : LoginUserModel.shared.data.user_idWORegionStr!, "cardNumder" : stripeCardParams.number!, "month" : stripeCardParams.expMonth!, "year" : stripeCardParams.expYear!, "cvc" : stripeCardParams.cvc!,"emailId" : UserDataModel.shared.data.email!] as [String : Any]
        
        
        NetworkManager.callService(url: "CardToken", parameters: parameters) { response in
            print(response)
            switch response{
            case .failed(let error):
                print(error)
                loading = false
                alertMsg = error
                isShowAlertView.toggle()
                break
            
            case .success(let responseData):
                loading = false
                let data = responseData["data"] as! [String:Any]
                let cardData = CardDetailModel(brand: data["brand"] as! String, expMonth: data["expMonth"] as! Int, expYear: data["expYear"] as! Int, id: data["id"] as! Int, last4: data["last4"] as! String, type: data["type"] as! String)
                
                delegate.sendCardParams(cardPara: stripeCardParams, response: cardData, isCardSave: isSaveCardforFuture)
                self.mode.projectedValue.wrappedValue.dismiss()

            break
            }
            loading = false
        }
    }
}

//struct CardDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardDetailView(delegate: self as! CardDetailDelegte)
//    }
//}

//MARK:- stripe payment card textfield
struct StripePaymentCardTextField: UIViewRepresentable {
    
    @Binding var cardParams: STPPaymentMethodCardParams
    @Binding var isValid: Bool
    
    func makeUIView(context: Context) -> STPPaymentCardTextField {
        let input = STPPaymentCardTextField()
        input.borderWidth = 0
        input.postalCodeEntryEnabled = false
        input.delegate = context.coordinator
        return input
    }
    
    func makeCoordinator() -> StripePaymentCardTextField.Coordinator { Coordinator(self) }
    
    func updateUIView(_ view: STPPaymentCardTextField, context: Context) { }
    
    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        
        var parent: StripePaymentCardTextField
        
        init(_ textField: StripePaymentCardTextField) {
            parent = textField
        }
        
        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            parent.cardParams = textField.cardParams
            parent.isValid = textField.isValid
        }
    }
}

// MARK: - Preview
struct StripePaymentCardTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            VStack {
                StripePaymentCardTextField(cardParams: .constant(STPPaymentMethodCardParams()), isValid: .constant(true))
            }
            
            VStack {
                StripePaymentCardTextField(cardParams: .constant(STPPaymentMethodCardParams()), isValid: .constant(true))
            }
            .environment(\.colorScheme, .dark)
        }
        .previewLayout(.fixed(width: 414, height: 50))
        
    }
}
