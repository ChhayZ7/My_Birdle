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
        guard let puzzle = puzzle else { return ""}
        let result = isSuccess ? "You got it!" : "Nope, try again!"
        let attempts = isSuccess ? "\(currentAttempt)/5" : "X/5"
        return """
            Birdle \(Date().formatted(date: .abbreviated, time: .omitted))
            \(result)
            Attempts: \(attempts)
            Bird: \(puzzle.name)
            Time: \(elapsedTimeString)
            
            Play at: Birdle App
            """
    }
    
    private var timer: Timer?
    private var startTime: Date?
    private var images: [UIImage?] = Array(repeating: nil, count: 6)
    
    // Initialisation
    init(){
        loadBirdNames()
    }
    
    func checkIfAlreadySolved(){
        alreadySolved = PersistenceController.shared.hasSolvedToday()
    }
    
    func loadPuzzle(){
        isLoading = true
        errorMessage = nil
        
        // Try to load from API
        NetworkService.shared.fetchDailyPuzzle { [weak self] result in
            DispatchQueue.main.async{
                switch result {
                case .success(let puzzle):
                    self?.puzzle = puzzle
                    self?.loadImages()
                case .failure:
                    self?.isLoading = false
                    self?.errorMessage = "Failed to load puzzle"
                    print("Failed to load puzzle")
                    return
                }
            }
        }
    }
    
    func startPuzzle(){
        hasStarted = true
        currentAttempt = 1
        startTime = Date()
        startTimer()
        loadNextImage()
    }
    
    func submitGuess(){
        guard !currentGuess.isEmpty else { return }
        
        let guess = currentGuess.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if correct
        if guess.lowercased() == puzzle?.name.lowercased() {
            handleCorrectGuess()
        } else {
            handleIncorrectGuess(guess)
        }
    }
    
    private func loadBirdNames(){
        // Hardcoded bird names matching the API
        birdNames = [
            "Tawny Frogmouth",
            "Australian Magpie",
            "Australian White Ibis"
        ].sorted()
        
        
        // Also load from API to get any updates
        NetworkService.shared.fetchBirdNames { [weak self] result in
            if case .success(let names) = result {
                DispatchQueue.main.async{
                    self?.birdNames = names.sorted()
                }
            }
        }
    }
    
    private func loadImages(){
        guard let puzzle = puzzle else {
            isLoading = false
            errorMessage = "No puzzle data available"
            return
        }
        
        isLoading = false
        
        // Download images
        for (index, urlString) in puzzle.imageURLs.enumerated() {
            NetworkService.shared.downloadImage(from: urlString) { [weak self] result in
                if case .success(let image) = result, index < 6
                {
                    DispatchQueue.main.async {
                        self?.images[index] = image
                        // Update current image if it's the one displayed
                        if index == (self?.currentAttempt ?? 1) - 1 {
                            self?.currentImage = image
                        }
                        // Update final image if loaded
                        if index == 5 {
                            self?.finalImage = image
                        }
                    }
                }
            }
        }
        
        
    }
    
    private func loadNextImage(){
        guard currentAttempt > 0 && currentAttempt <= images.count else { return }
        currentImage = images[currentAttempt - 1]
    }
    
    private func handleCorrectGuess(){
        stopTimer()
        isCompleted = true
        isSuccess = true
        finalImage = images[5]
        
        // Save to history
        if let puzzle = puzzle, let startTime = startTime {
            let result = PuzzleResult(
                birdName: puzzle.name,
                attempts: currentAttempt,
                timeSpent: Date().timeIntervalSince(startTime),
                date: Date(),
                imageUrl: puzzle.finalImageURL,
                photographer: puzzle.photographer,
                license: puzzle.license,
                wikiLink: puzzle.bird_link
            )
            PersistenceController.shared.savePuzzleResult(result)
        }
        
        currentGuess = ""
    }
    
    private func handleIncorrectGuess(_ guess: String){
        previousGuesses.append(guess)
        currentGuess = ""
        
        if currentAttempt >= 5 {
            // Failed: show answer
            stopTimer()
            isCompleted = true
            isSuccess = false
            finalImage = images[5]
            
            // Save to history (with max attempts)
            if let puzzle = puzzle, let startTime = startTime {
                let result = PuzzleResult(
                    birdName: puzzle.name,
                    attempts: 5,
                    timeSpent: Date().timeIntervalSince(startTime),
                    date: Date(),
                    imageUrl: puzzle.finalImageURL,
                    photographer: puzzle.photographer,
                    license: puzzle.license,
                    wikiLink: puzzle.bird_link
                )
                PersistenceController.shared.savePuzzleResult(result)
            }
        } else {
                // Show next image
                currentAttempt += 1
                loadNextImage()
                showIncorrectAlert = true
        }
    }
        
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ [weak self] _ in
            guard let startTime = self?.startTime else { return }
            self?.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
}
