//
//  ContentView.swift
//  MathGame
//
//  Created by HLK on 6/20/24.
//


import SwiftUI
import AVFoundation

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0x00ff00) >> 8
        let blue = rgbValue & 0x0000ff
        
        self.init(
            .sRGB,
            red: Double(red) / 0xff,
            green: Double(green) / 0xff,
            blue: Double(blue) / 0xff,
            opacity: 1
        )
    }
}

struct ContentView: View {
    
    @State private var correctAnswer = 0
    @State private var choiceArray: [Int] = [0, 1, 2, 3]
    @State private var firstNum = 0
    @State private var secondNum = 0
    @State private var difficulty = 100
    @State private var score = 0
    @State private var gameOver = false
    @State private var timer: Timer?
    @State private var timeRemaining = 30
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var isGameStarted = false
    @State private var timerSpeed = 1.0
    @State private var highScore = UserDefaults.standard.integer(forKey: "HighScore")
    
    var body: some View {
        if isGameStarted {
            gameView
                .onAppear {
                    startGame()
                }
        } else {
            StartPage(selectedDifficulty: $selectedDifficulty, isGameStarted: $isGameStarted)
                .onAppear {
                    setDifficulty()
                }
        }
    }
    
    var gameView: some View {
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
                
                Text("\(firstNum) + \(secondNum)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                HStack {
                    ForEach(0..<2) { index in
                        Button {
                            answerIsCorrect(answer: choiceArray[index])
                            generateAnswers()
                        } label: {
                            AnswerButton(number: choiceArray[index])
                        }
                    }
                }
                HStack {
                    ForEach(2..<4) { index in
                        Button {
                            answerIsCorrect(answer: choiceArray[index])
                            generateAnswers()
                        } label: {
                            AnswerButton(number: choiceArray[index])
                        }
                    }
                }
                
                Text("Score: \(score)")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                Text("Time: \(timeRemaining)")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                if gameOver {
                    VStack {
                        Text("Game Over")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("High Score: \(highScore)")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                        
                        Button("Restart") {
                            resetGame()
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func answerIsCorrect(answer: Int) {
        if answer == correctAnswer {
            self.score += 1
            playSound(sound: "correct")
        } else {
            if self.score > 0 {
                self.score -= 1
                playSound(sound: "wrong")
            } else {
                playSound(sound: "wrong")
            }
        }
    }
    
    func generateAnswers() {
        firstNum = Int.random(in: 0...(difficulty / 2))
        secondNum = Int.random(in: 0...(difficulty / 2))
        var answerList = [Int]()
        
        correctAnswer = firstNum + secondNum
        
        for _ in 0...2 {
            answerList.append(Int.random(in: 0...difficulty))
        }
        
        answerList.append(correctAnswer)
        
        choiceArray = answerList.shuffled()
    }
    
    func startGame() {
        generateAnswers()
        startTimer()
    }
    
    func resetGame() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighScore")
        }
        
        score = 0
        timeRemaining = 30
        gameOver = false
        startGame()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timerSpeed, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                gameOver = true
                timer?.invalidate()
            }
        }
    }
    
    func setDifficulty() {
        switch selectedDifficulty {
        case .easy:
            difficulty = 50
            timerSpeed = 1.0
        case .medium:
            difficulty = 100
            timerSpeed = 0.75
        case .hard:
            difficulty = 200
            timerSpeed = 0.15
        }
    }
    
    func playSound(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        
        var soundEffect: AVAudioPlayer?
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        } catch {
            print("Could not load sound file.")
        }
    }
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
