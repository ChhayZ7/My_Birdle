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
                
//                if viewModel.isLoading {
//                    LoadingView()
//                }
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
        }
    }
}
struct PuzzleView_Previews: PreviewProvider{
    static var previews: some View {
//        PuzzleView()
        StartView()
    }
}

