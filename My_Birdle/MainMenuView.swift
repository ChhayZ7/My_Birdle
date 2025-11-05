//
//  MainMenuView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 5/11/2025.
//

import SwiftUI

struct MainMenuView: View {
    @State private var showPuzzle = false
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
                    VStack
                }
            }
        }
    }
}

#Preview {
    MainMenuView()
}

