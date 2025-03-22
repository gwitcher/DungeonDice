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
    @State private var  columns = [
        GridItem(.adaptive(minimum: 102)),
    ]
    @State private var animationTrigger = false
    @State private var isDoneAnimating = true
    
    
    var body: some View {
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
            
            LazyVGrid(columns: columns) {
                ForEach(Dice.allCases) { dice in
                    Button(dice.description) {
                        resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                        animationTrigger.toggle()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
