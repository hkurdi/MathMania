//
//  AnswerButton.swift
//  MathGame
//
//  Created by HLK on 6/20/24.
//

import SwiftUI

struct AnswerButton: View {
    var number: Int
    var body: some View {
        Text("\(number)")
            .frame(width: 110, height: 110)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Circle())
            .shadow(radius: 10)
            .padding()
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(number: 100)
    }
}
