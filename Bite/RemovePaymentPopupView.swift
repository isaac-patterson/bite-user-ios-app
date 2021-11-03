//
//  RemovePaymentPopupView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 16/07/21.
//

import SwiftUI

struct RemovePaymentPopupView<T:View>: ViewModifier {
    
    let popup: T
    let isPresented: Bool
    
    init(isPresented: Bool, @ViewBuilder content: () -> T) {
        self.isPresented = isPresented
        popup = content()
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(popupContent())
    }
    
    @ViewBuilder private func popupContent() -> some View {
        GeometryReader { geometry in
            if isPresented {
                body
                    .animation(.spring())
                    .transition(.offset(x: 0, y: geometry.belowScreenEdge))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
            }
        }
    }
    
    var body: some View {
        
        VStack{
            Spacer().frame(height:35)
            Text("remove payment method")
                .font(.custom("Quicksand-Bold", fixedSize: 18))
                .foregroundColor(Color.init("AppThemeMusturd"))
            Spacer().frame(height:35)
            Divider()
                .background(Color.init("AppThemeMusturd"))
            Spacer().frame(height:65)
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Delete")
                    .foregroundColor(Color.init(hex: "E50E0E"))
                    .font(.custom("Quicksand-Bold", fixedSize: 18))
            })
            .frame(width: UIScreen.main.bounds.width, height: 58, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Cancel")
                    .foregroundColor(Color.init("AppThemeMusturd"))
                    .font(.custom("Quicksand-Bold", fixedSize: 18))
            })
            .frame(width: UIScreen.main.bounds.width, height: 58, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
        .frame(width: 375, height: 280, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        .cornerRadius(5)
    }
}

struct RemovePaymentPopupView_Previews: PreviewProvider {
    static var previews: some View {
        Color.white
            .modifier(RemovePaymentPopupView(isPresented: true, content: {
                Color.clear.frame(width: 375, height: 280, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }))
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 280))
    }
}
