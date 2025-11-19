//
//  MainMenuView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 5/11/2025.
//

import SwiftUI

struct MainMenuView: View {
    @State private var showPuzzle = false
    @State private var showPractice = false
    @State private var showHelp = false
    @State private var showHistory = false
    @State private var showUpload = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                ).ignoresSafeArea()
                
                VStack(spacing: 30){
                    // Header
                    VStack(spacing: 10){
                        Image(systemName: "bird.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                        
                        Text("Birdle")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Daily Bird Guessing Puzzle")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Menu bottons
                    VStack(spacing: 20){
                        MenuButton(
                            title: "Start Puzzle",
                            icon: "play.circle.fill",
                            color: .green
                        ) {
                            print("Start Puzzle")
                            showPuzzle = true
                        }
                        
                        MenuButton(
                            title: "Practice",
                            icon: "gamecontroller.fill",
                            color: .blue
                        ){
                            showPractice = true
                        }
                        
                        MenuButton(
                            title: "Upload Bird",
                            icon: "square.and.arrow.up.circle.fill",
                            color: .purple
                        ) {
                            showUpload = true
                        }
                        
                        MenuButton(
                            title: "History",
                            icon: "clock.fill",
                            color: .orange
                        ) {
                            showHistory = true
                        }
                        
                        MenuButton(
                            title: "Help",
                            icon: "questionmark.circle.fill",
                            color: .blue
                        ) {
                            showHelp = true
                        }
                        
                        MenuButton(
                            title: "About",
                            icon: "info.circle.fill",
                            color: .gray
                        ) {
                            showAbout = true
                        }
                    }
                    .padding(.horizontal, 70)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showPuzzle){
                PuzzleView()
            }
            .fullScreenCover(isPresented: $showPractice){
                PracticeView()
            }
            .sheet(isPresented: $showHelp){
                 HelpView()
            }
            .sheet(isPresented: $showHistory){
                 HistoryView()
            }
            .sheet(isPresented: $showUpload){
                 UploadView()
            }
            .sheet(isPresented: $showAbout){
                 AboutView()  
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(15)
            .shadow(color: color.opacity(0.4), radius: 5,
                    x: 0, y: 3)
        }
    }
}

#Preview {
    MainMenuView()
}

