//
//  PuzzleView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 6/11/2025.
//

import SwiftUI

struct PuzzleView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PuzzleViewModel()

    var body: some View {
        NavigationView {
            ZStack{
                // Background
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error){
                        viewModel.loadPuzzle()
                    }
                } else if viewModel.alreadySolved {
                    AlreadySolvedView(dismiss: dismiss)
                } else if !viewModel.hasStarted {
                    StartView {
                        viewModel.startPuzzle()
                }
                } else if viewModel.isCompleted{
                    ResultView(
                        viewModel: viewModel,
                        dismiss: dismiss
                        )
                } else {
                    PuzzleGameView(viewModel: viewModel)
                }
            }
        }
    }
}

// Start View
struct StartView: View {
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 30){
            Image(systemName: "bird.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.blue)
            
            VStack(spacing: 15){
                Text("Ready to Play?")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Guess today's bird in 5 tries or less!")
                    .font(.title)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onStart){
                HStack{
                    Image(systemName: "play.fill")
                    Text("Start Puzzle")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: 250)
                .padding()
                .background(Color.green)
                .cornerRadius(15)
            }
        }
        .padding()
    }
}

// Already Solved View
struct AlreadySolvedView: View {
    let dismiss: DismissAction
    
    var body: some View{
        VStack(spacing: 30){
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            VStack(spacing: 15){
                Text("Already Completed!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("You've already solved today's puzzle.\nCome back tomorrow for new bird!")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { dismiss()}){
                Text("Back to Menu")
                    .fontWeight(.semibold)
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

// Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20){
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading puzzle...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// Error View
struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "exclamation.triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.orange)
            
            Text("Oops!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                multilineTextAlignment(.center)
            
            Button(action: retry) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .frame(minWidth: 100)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
struct PuzzleView_Previews: PreviewProvider{
    static var previews: some View {
        PuzzleView()
    }
}

