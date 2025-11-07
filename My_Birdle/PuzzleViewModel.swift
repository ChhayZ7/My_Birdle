//
//  PuzzleViewModel.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 6/11/2025.
//
import SwiftUI

class PuzzleViewModel: ObservableObject {
    // Puzzle properties
    @Published var puzzle: BirdPuzzle?
    @Published var currentAttempt = 0
    @Published var currentGuess = ""
    @Published var previousGuesses: [String] = []
    @Published var hasStarted = false
    @Published var isCompleted = false
    @Published var isSuccess = false
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var showIncorrectAlert = false
    @Published var alreadySolved = false
    
    @Published var currentImage: UIImage?
    @Published var finalImage: UIImage?
    @Published var elapsedTime: TimeInterval = 0
    
    // Bird names for autocomplete
    @Published var birdNames: [String] = []
    
    // Computed Properties
    var filteredSuggestions: [String] {
        guard !currentGuess.isEmpty else {
            return []
        }
        return birdNames.filter { $0.lowercased().contains(currentGuess.lowercased())}
            .sorted()
    }
    
    var elapsedTimeString: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var shareText: String {
        
    }
    
    
}
