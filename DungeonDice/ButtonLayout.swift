//
//  ButtonLayout.swift
//  DungeonDice
//
//  Created by Gabe Witcher on 3/22/25.
//

import SwiftUI

struct ButtonLayout: View {
    enum Dice: Int, CaseIterable, Identifiable {
        case four = 4
        case six = 6
        case eight = 8
        case ten = 10
        case twelve = 12
        case twenty = 20
        case hundred = 100
        
        var id: Int {rawValue} //Each rawValue is unique so it's a good ID
        var description: String {"\(rawValue)-sided"}
        
        func roll() -> Int {
            return Int.random(in: 1...self.rawValue)
        }
    }
    
    //A preference key structure used to pass values up from child to parent
    
    struct DeviceWidthPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        
        typealias Value = CGFloat
    }
    
    
    @State private var buttonsLeftOver = 0 // # of buttons in a less than full row
    @Binding var resultMessage: String
    @Binding var animationTrigger: Bool
    
    let horizontalPadding: CGFloat = 16
    let spacing: CGFloat = 0 // betwen buttons
    let buttonWidth: CGFloat = 102
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: buttonWidth), spacing: spacing)]) {
                ForEach(Dice.allCases.dropLast(buttonsLeftOver)) { dice in
                    Button(dice.description) {
                        resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                        animationTrigger.toggle()
                    }
                    .frame(width: buttonWidth)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
            HStack {
                ForEach(Dice.allCases.suffix(buttonsLeftOver)) { dice in
                    Button(dice.description) {
                        resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                        animationTrigger.toggle()
                    }
                    .frame(width: buttonWidth)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .preference(key: DeviceWidthPreferenceKey.self, value: geo.size.width)
            }
        }
        .onPreferenceChange(DeviceWidthPreferenceKey.self) { deviceWidth in
            arrangeGridItems(deviceWidth: deviceWidth)
        }
    }
    func arrangeGridItems(deviceWidth: CGFloat) {
        var screenWidth = deviceWidth - horizontalPadding*2 //padding on both sides of buttons
        if Dice.allCases.count > 1 {
            screenWidth += spacing
        }
        //calculate number of buttons per row as Int
        let numberOfButtonsPerRow = Int(screenWidth) / Int(buttonWidth + spacing)
        buttonsLeftOver = Dice.allCases.count % numberOfButtonsPerRow
        print("Buttons left over = \(buttonsLeftOver)")
    }
}

#Preview {
    ButtonLayout(resultMessage: .constant(""), animationTrigger: .constant(false))
}
