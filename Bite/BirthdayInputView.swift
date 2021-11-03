//
//  BirthdayInputView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 08/09/21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct BirthdayInputView: View {
    
    @State var birthday = ""
    @State var isShowPassView: Bool = false
    @ObservedObject var signupData = SignupModel.shared
    @State var isShowAlertView: Bool = false
    @State var alertViewMsg = ""
    @State var showDatePicker = false
    @State var date = Date()
    @State var popoverSize = CGSize(width: 320, height: 300)
    let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Group{
                    BackButtonBarView()
                }
                Spacer().frame(height: 30)
                Group{
                    Text("What's your Birth Date?")
                        .font(.custom("Quicksand-Bold", fixedSize: 28))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                    
                    Spacer().frame(height: 10)
                    
                    Text("For receipts")
                        .font(.custom("Quicksand-Bold", fixedSize: 18))
                        .foregroundColor(Color.init("AppThemeMusturd"))
                    
                    Spacer().frame(height: 175)
                }
                WithPopover(showPopover: $showDatePicker, popoverSize: popoverSize) {
                    
                    VStack{
                        FloatingLabelTextField($birthday, placeholder: "Birth Date") { (isChanged) in
                        } commit: {
                            
                        }
                        .floatingStyle(ThemeTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width-100,height: 70)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                    .background(Color.white)
                    .frame(width: UIScreen.main.bounds.width-100,height: 70)
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
                    self.birthday = dateformatter.string(from: date)
                })
                
                Spacer().frame(height: 154)
                
                Button(action: {
                    if birthday == ""{
                        isShowAlertView.toggle()
                        alertViewMsg = "Please Select Birth Date"
                    }else{
                        isShowPassView.toggle()
                    }
                }, label: {
                    Text("Next")
                        .font(.custom("Quicksand-Bold", size: 24))
                        .frame(width: (UIScreen.main.bounds.size.width-108), height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .background(Color.init("AppThemeMusturd"))
                .cornerRadius(30)
                .foregroundColor(.white)
                
                NavigationLink(
                    destination: StudentConfirmationView(),
                    isActive: $isShowPassView){
                    EmptyView()
                }
                .alert(isPresented: $isShowAlertView, title: "Alert", message: alertViewMsg)
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
    }
}

struct BirthdayInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayInputView()
    }
}
//MARK:- PopUp date Picker
struct WithPopover<Content: View, PopoverContent: View>: View {
    
    @Binding var showPopover: Bool
    var popoverSize: CGSize? = nil
    let content: () -> Content
    let popoverContent: () -> PopoverContent
    
    var body: some View {
        content()
            .background(
                Wrapper(showPopover: $showPopover, popoverSize: popoverSize, popoverContent: popoverContent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
    }
    
    struct Wrapper<PopoverContent: View> : UIViewControllerRepresentable {
        
        @Binding var showPopover: Bool
        let popoverSize: CGSize?
        let popoverContent: () -> PopoverContent
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<Wrapper<PopoverContent>>) -> WrapperViewController<PopoverContent> {
            return WrapperViewController(
                popoverSize: popoverSize,
                popoverContent: popoverContent) {
                self.showPopover = false
            }
        }
        
        func updateUIViewController(_ uiViewController: WrapperViewController<PopoverContent>,
                                    context: UIViewControllerRepresentableContext<Wrapper<PopoverContent>>) {
            uiViewController.updateSize(popoverSize)
            
            if showPopover {
                uiViewController.showPopover()
            }
            else {
                uiViewController.hidePopover()
            }
        }
    }
    
    class WrapperViewController<PopoverContent: View>: UIViewController, UIPopoverPresentationControllerDelegate {
        
        var popoverSize: CGSize?
        let popoverContent: () -> PopoverContent
        let onDismiss: () -> Void
        
        var popoverVC: UIViewController?
        
        required init?(coder: NSCoder) { fatalError("") }
        init(popoverSize: CGSize?,
             popoverContent: @escaping () -> PopoverContent,
             onDismiss: @escaping() -> Void) {
            self.popoverSize = popoverSize
            self.popoverContent = popoverContent
            self.onDismiss = onDismiss
            super.init(nibName: nil, bundle: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        func showPopover() {
            guard popoverVC == nil else { return }
            let vc = UIHostingController(rootView: popoverContent())
            if let size = popoverSize { vc.preferredContentSize = size }
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            if let popover = vc.popoverPresentationController {
                popover.sourceView = view
                popover.delegate = self
            }
            popoverVC = vc
            self.present(vc, animated: true, completion: nil)
        }
        
        func hidePopover() {
            guard let vc = popoverVC, !vc.isBeingDismissed else { return }
            vc.dismiss(animated: true, completion: nil)
            popoverVC = nil
        }
        
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            popoverVC = nil
            self.onDismiss()
        }
        
        func updateSize(_ size: CGSize?) {
            self.popoverSize = size
            if let vc = popoverVC, let size = size {
                vc.preferredContentSize = size
            }
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none // this is what forces popovers on iPhone
        }
    }
}

