import SwiftUI

struct ConfirmationCodeSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State var confirmationCodeTextField: String = ""
    
    var maxDigits: Int = 6
    var label = "Enter confirmation code"
    @State var pin: String = ""
    
    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    pinDots
                    backgroundField
                }
                
                HStack {
                    Text("Resend pin")
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Spacer()
                    
                    Button("Confirm") {
                        print(pin)
                        dismissModal()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                }
                .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))

            }
            .navigationTitle("Confirm code")
        }
        .colorMultiply(Color(UIColor.systemGray3))

    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            
            ForEach(0..<maxDigits) { index in
                Image(systemName:
                        index >= self.pin.count ? "square" : self.pin.digits[index].numberString + ".square"
                )
                    .font(.system(size: 35, weight: .thin, design: .default))
            }
            
            Spacer()
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(
            get: { self.pin },
            set: {newValue in self.pin = newValue }
            )
        
        return TextField("", text: boundPin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
    }
}

extension String {
    var digits: [Int] {
        var result = [Int]()
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        return result
    }
}

extension Int {
    var numberString: String {
        guard self < 10 else { return "0" }
        return String(self)
    }
}
