//
//  HelpView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 11/11/2025.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 25){
                    // Header
                    VStack(spacing: 10){
                        Image(systemName: "bird.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.blue)
                        
                        Text("How to Play Birdle")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    
                    Divider()
                    
                    // Instructions
                    InstructionSection(
                        icon: "1.circle.fill",
                        title: "Start the Puzzle",
                        description: "Each day features a new bird to identify. Press 'Start Puzzle' to begin."
                        )
                    
                    InstructionSection(
                        icon: "2.circle.fill",
                        title: "Look at the Image",
                        description: "You'll see the first image of the bird. Study it carefully for clues about the species."
                        )
                    
                    InstructionSection(
                        icon: "3.circle.fill",
                        title: "Make Your Guess",
                        description: "Type the name of the bird you think it is. You can use the autocomplete suggestions to help you."
                        )
                    
                    InstructionSection(
                        icon: "4.circle.fill",
                        title: "Gte Feedback",
                        description: "If you're correct, you win! If not, you'll see the next image. You have up to 5 attempts."
                        )

                    InstructionSection(
                        icon: "5.circle.fill",
                        title: "Complete the Puzzle",
                        description: "After 5 incorrect guesses, the answer is revealed. Either way, you'll see information about the bird and the photographer."
                        )
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10){
                        Label("Tips", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        
                        TipRow(tip: "Look for distinctive features like colors, beak shape, and size")
                        TipRow(tip: "Consider the bird's habitat and behavior shown in the images")
                        TipRow(tip: "Use the autocomplete to browse bird names")
                        TipRow(tip: "You can only attempt each puzzle once per day")
                        TipRow(tip: "Check your history to review past puzzles")
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done"){
                        dismiss()
                    }
                }
            }
        }
    }
}

// Instruction Section Component
struct InstructionSection: View{
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15){
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5){
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// Tip Row Component
struct TipRow: View{
    let tip: String
    
    var body: some View{
        HStack(alignment: .top, spacing: 10){
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.orange)
            
            Text(tip)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
#Preview {
    HelpView()
}
