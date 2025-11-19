//
//  PracticeView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 19/11/2025.
//

import SwiftUI


struct PracticeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPuzzle: PracticePuzzle?
    @State private var showPuzzle = false
    
    // 5 hardcoded practice puzzles (defined in NetworkService)
    let practicePuzzles = [
        PracticePuzzle(id: 1, name: "Puzzle 1", difficulty: "Easy", icon: "1.circle.fill", color: .green),
        PracticePuzzle(id: 2, name: "Puzzle 2", difficulty: "Easy", icon: "2.circle.fill", color: .green),
        PracticePuzzle(id: 3, name: "Puzzle 3", difficulty: "Medium", icon: "3.circle.fill", color: .orange),
        PracticePuzzle(id: 4, name: "Puzzle 4", difficulty: "Medium", icon: "4.circle.fill", color: .orange),
        PracticePuzzle(id: 5, name: "Puzzle 5", difficulty: "Hard", icon: "5.circle.fill", color: .red)
    ]
    var body: some View {
        NavigationView{
            ZStack{
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack(spacing: 20){
                        // Header
                        VStack(spacing: 10){
                            Image(systemName: "gamecontroller.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.blue)
                            
                            Text("Practice Mode")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Try these 5 practice puzzles!\nNo limits - play as many as you like!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        // Puzzle list
                        VStack(spacing: 15){
                            ForEach(practicePuzzles){ puzzle in
                                PracticePuzzleCard(puzzle: puzzle){
                                    selectedPuzzle = puzzle
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done"){
                        dismiss()
                    }
                }
            }
            // Present selected puzzle
            .fullScreenCover(item: $selectedPuzzle) { puzzle in
                PracticePuzzleView(puzzleId: puzzle.id)
            }
        }
    }
}

// Practice Puzzle Card
struct PracticePuzzleCard: View {
    let puzzle: PracticePuzzle
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            HStack(spacing: 15){
                // Icon
                Image(systemName: puzzle.icon)
                    .font(.system(size: 40))
                    .foregroundStyle(puzzle.color)
                    .frame(width: 60)
                
                // Info
                VStack(alignment: .leading, spacing: 5){
                    Text(puzzle.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .font(.caption)
                        Text(puzzle.difficulty)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                }
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

// Practice Puzzle View Wrapper
// Wraps PuzzleView with practice mode enabled
struct PracticePuzzleView: View {
    let puzzleId: Int
    @Environment(\.dismiss) var dismiss
    @StateObject private var controller: PuzzleController
    
    init(puzzleId: Int) {
        self.puzzleId = puzzleId
        // Initialise controller in practice mode
        _controller = StateObject(wrappedValue: PuzzleController(practiceMode: true, puzzleId: puzzleId))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if controller.isLoading {
                    LoadingView()
                } else if let error = controller.errorMessage {
                    ErrorView(message: error) {
                        controller.loadPuzzle()
                    }
                } else if !controller.hasStarted {
                    PracticeStartView(puzzleNumber: puzzleId) {
                        controller.startPuzzle()
                    }
                } else if controller.isCompleted {
                    PracticeResultView(
                        controller: controller,
                        dismiss: dismiss
                    )
                } else {
                    PuzzleGameView(controller: controller)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Exit") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                controller.checkIfAlreadySolved()
                controller.loadPuzzle()
            }
        }
    }
}

// Practice Start View
struct PracticeStartView: View {
    let puzzleNumber: Int
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "\(puzzleNumber).circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.blue)
            
            VStack(spacing: 15) {
                Text("Practice Puzzle \(puzzleNumber)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Guess the bird in 5 tries or less!\nThis is practice mode - play as many times as you want.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onStart) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Practice")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: 250)
                .padding()
                .background(Color.blue)
                .cornerRadius(15)
            }
        }
        .padding()
    }
}

// Practice Result View
// Similar to daily result but allows retry
struct PracticeResultView: View {
    @ObservedObject var controller: PuzzleController
    let dismiss: DismissAction
    @State private var showShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Success/Failure header
                VStack(spacing: 15) {
                    Image(systemName: controller.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(controller.isSuccess ? .green : .orange)
                    
                    Text(controller.isSuccess ? "Great Job!" : "Good Try!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Practice mode badge
                    Text("Practice Mode")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(20)
                    
                    if controller.isSuccess {
                        Text("You guessed it in \(controller.currentAttempt) \(controller.currentAttempt == 1 ? "try" : "tries")!")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("You've used all 5 attempts.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Time: \(controller.elapsedTimeString)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                // Final bird image reveal
                if let image = controller.finalImage {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        
                        Text(controller.puzzle?.photographer ?? "Unknown")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(controller.puzzle?.license ?? "")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                // Bird information
                if let puzzle = controller.puzzle {
                    VStack(alignment: .leading, spacing: 15) {
                        Text(puzzle.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Photographer: \(puzzle.photographer)")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        Text("License: \(puzzle.license)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if let birdLink = puzzle.bird_link, let url = URL(string: birdLink) {
                            Link(destination: url) {
                                HStack {
                                    Image(systemName: "link.circle.fill")
                                    Text("Learn More")
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                // Practice mode actions
                // Unlike daily mode, this allows retry
                VStack(spacing: 15) {
                    Button(action: {
                        // Restart the same puzzle
                        controller.hasStarted = false
                        controller.isCompleted = false
                        controller.currentAttempt = 0
                        controller.previousGuesses = []
                        controller.currentGuess = ""
                        controller.elapsedTime = 0
                        controller.loadPuzzle()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Try Again")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Back to Practice Menu")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    PracticeView()
}
