//
//  PuzzleGameView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 12/11/2025.
//
// Active puzzle gameplay view

import SwiftUI

struct PuzzleGameView: View {
    @ObservedObject var controller: PuzzleController
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ScrollView{
            VStack(spacing: 25){
                // Attempt counter
                HStack{
                    Text("Attempt \(controller.currentAttempt) of 5")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(controller.elapsedTimeString)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                .padding(.horizontal)
                
                // Bird image
                if let image = controller.currentImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .cornerRadius(15)
                        .overlay(
                            ProgressView()
                        )
                        .padding(.horizontal)
                }
                
                // Previous attempts
                if !controller.previousGuesses.isEmpty {
                    VStack(alignment: .leading, spacing: 10){
                        Text("Previous Guesses:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        ForEach(controller.previousGuesses, id: \.self){ guess in
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                                Text(guess)
                                    .strikethrough()
                            }
                            .font(.body)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Guess input
                VStack(spacing: 15){
                    TextField("Enter bird name...", text: $controller.currentGuess)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .focused($isInputFocused)
                        .padding(.horizontal)
                    
                    // Autocomplete suggestions
                    if !controller.filteredSuggestions.isEmpty && isInputFocused {
                        ScrollView {
                            VStack(spacing: 5){
                                ForEach(controller.filteredSuggestions.prefix(5), id: \.self) {
                                    suggestion in
                                    Button(action: {
                                        controller.currentGuess = suggestion
                                        isInputFocused = false
                                    }) {
                                        HStack {
                                            Text(suggestion)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                    }
                                    Divider()
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    Button(action: {
                        controller.submitGuess()
                        isInputFocused = false
                    }) {
                        Text("Submit Guess")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(controller.currentGuess.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(12)
                    }
                    .disabled(controller.currentGuess.isEmpty)
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.vertical)
        }
        .alert("Incorrect!", isPresented: $controller.showIncorrectAlert){
            Button("OK", role: .cancel) {}
        } message: {
            Text("That's not quite right. Try again!")
        }
    }
}

// Result View
struct ResultView: View{
    @ObservedObject var controller: PuzzleController
    let dismiss: DismissAction
    @State private var showShareSheet = false
    
    var body: some View{
        ScrollView {
            VStack(spacing: 25){
                // Success/Failure header
                VStack(spacing: 15){
                    Image(systemName: controller.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(controller.isSuccess ? .green : .orange)
                    
                    Text(controller.isSuccess ? "Congratulations!" : "Better Luck Next Time!")
                        .font(.title)
                        .fontWeight(.bold)
                    
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
                
                // Final bird image
                if let image = controller.finalImage{
                    VStack(alignment: .leading, spacing: 10){
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
                if let puzzle = controller.puzzle{
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
                        
                        Link(destination: URL(string: puzzle.bird_link ?? "https://wikipedia.org")!){
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
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                // Action buttons
                VStack(spacing: 15){
                    Button(action: {
                        showShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Results")
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
                            Image(systemName: "house.fill")
                            Text("Back to Menu")
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
            .sheet(isPresented: $showShareSheet){
                ShareSheet(activityItems: [controller.shareText])
            }
        }
    }
}

// Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    PuzzleGameView(controller: PuzzleController())
}
