//
//  ContentView.swift
//  DungeonDice
//
//  Created by Gabe Witcher on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    enum Dice: Int, CaseIterable, Identifiable {
        
        case four = 4
        case six = 6
        case eight = 8
        case ten = 10
        case twelve = 12
        case twenty = 20
        case hundred = 100
        
        var id: Int {
            rawValue //Each rawValue is unique so it's a good ID
        }
        
        var description: String {
            "\(rawValue)-sided"
        }
        
        
        func roll() -> Int {
            return Int.random(in: 1...self.rawValue)
        }
    }
    
    @State private var resultMessage = ""
    @State private var buttonsLeftOver = 0 // # of buttons in a less than full row
    let horizontalPadding: CGFloat = 16
    let spacing: CGFloat = 0 // betwen buttons
    let buttonWidth: CGFloat = 102
    
    //    @State private var  columns = [
    //        GridItem(.adaptive(minimum: buttonWidth)),
    //    ]
    @State private var animationTrigger = false
    @State private var isDoneAnimating = true
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Dungeon Dice")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(resultMessage)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .frame(height: 150)
                    .multilineTextAlignment(.center)
                //                .scaleEffect(isDoneAnimating ? 1.0 : 0.5)
                //                .opacity(isDoneAnimating ? 1.0 : 0.2)
                    .rotation3DEffect(isDoneAnimating ? .degrees(360) : .degrees(0), axis: (x: 1, y: 0, z: 0))
                    .onChange(of: animationTrigger) {
                        isDoneAnimating = false
                        withAnimation(.interpolatingSpring(duration: 0.6, bounce: 0.4)) {
                            isDoneAnimating = true
                        }
                    }
                
                Spacer()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: buttonWidth), spacing: spacing)]) {
                    ForEach(Dice.allCases.dropLast(buttonsLeftOver)) { dice in
                        Button(dice.description) {
                            resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                            animationTrigger.toggle()
                        }
                        .frame(width: buttonWidth)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
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
            .padding()
            .onChange(of: geo.size.width, { oldValue, newValue in
                arrangeGridItems(geo: geo)
            })
            .onAppear {
                arrangeGridItems(geo: geo)
                
            }
        }
        
    }
    
    func arrangeGridItems(geo: GeometryProxy) {
        var screenWidth = geo.size.width - horizontalPadding*2 //padding on both sides of buttons
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
    ContentView()
}
