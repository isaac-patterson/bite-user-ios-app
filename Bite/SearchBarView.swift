//
//  SearchBarView.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 12/07/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
            Spacer().frame(width:13)
            Image("searchIcon")
            TextField("Search", text: $text)
                .font(.custom("SourceSansPro-Light", size: 20))
                .padding(7)
                .padding(.horizontal, 0)
                .background(Color(.clear))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .frame(height: 36)
    }
}
