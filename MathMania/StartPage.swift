//
//  StartPage.swift
//  MathGame
//
//  Created by HLK on 6/20/24.
//

import Foundation
import SwiftUI

struct StartPage: View {
    @Binding var selectedDifficulty: Difficulty
    @Binding var isGameStarted: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "36d1dc"), Color(hex: "5b86e5")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Math Mania")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                Text("CS50 Final Project by Hamza Kurdi")
                    .font(.caption)
                    .underline()
                
                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue.capitalized).tag(difficulty)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: {
                    isGameStarted = true
                }) {
                    Text("Play")
                        .font(.title)
                        .bold()
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
}


