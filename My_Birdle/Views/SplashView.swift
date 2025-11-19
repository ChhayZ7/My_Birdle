//
//  SplashView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 5/11/2025.
//

import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.blue.opacity(1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            VStack(spacing: 20){
                // Animated bird icon
                Image(systemName: "bird.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                // App name
                Text("Birdle")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(opacity)
                
                Text("Guess the Bird!")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(opacity)
            }
            
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)){
                scale = 1
                opacity = 1
            }

            // Auto-dismiess after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider{
    static var previews: some View {
        SplashView(showSplash: .constant(true))
    }
}
