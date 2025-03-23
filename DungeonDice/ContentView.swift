//
//  ContentView.swift
//  DungeonDice
//
//  Created by Gabe Witcher on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var resultMessage = ""
    @State private var animationTrigger = false
    @State private var isDoneAnimating = true
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                titleView
                
                Spacer()
                
                resultMessageView
                
                Spacer()
                
                ButtonLayout(resultMessage: $resultMessage, animationTrigger: $animationTrigger)
            }
            .padding()
        }
    }
}

extension ContentView {
    private var titleView: some View {
        Text("Dungeon Dice")
            .font(.largeTitle)
            .fontWeight(.black)
            .foregroundStyle(.red)
    }
    
    private var resultMessageView: some View {
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
    }
    
}

#Preview {
    ContentView()
}
