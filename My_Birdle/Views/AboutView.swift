//
//  AboutView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 11/11/2025.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // App icon and name
                    VStack(spacing: 15){
                        Image(systemName: "bird.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.blue)
                        
                        Text("Birdle")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                                  
                        Text("Version 1.0")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                    
                    Divider()
                    
                    // App features
                    VStack(alignment: .leading, spacing: 15){
                        SectionHeader(title: "Feature")
                        
                        FeatureRow(
                            icon: "puzzlepiece.fill",
                            title: "Daily & Practice Puzzle",
                            description: "Practice or Guess a new bird every day")
                        
                        FeatureRow(
                            icon: "clock.fill",
                            title: "History Tracking",
                            description: "Review your past attempts"
                        )
                        
                        FeatureRow(
                            icon: "square.and.arrow.up.fill",
                            title: "Upload Birds",
                            description: "Share your bird photos"
                        )
                        
                        FeatureRow(
                            icon: "chart.bar.fill",
                            title: "Progress Tracking",
                            description: "See your improvement over time"
                        )
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)

                    // Developer info
                    VStack(alignment: .leading, spacing: 20){
                        SectionHeader(title: "Developer")
                        
                        InfoRow(label: "Name", value: "Kimchhay Leng")
                        InfoRow(label: "Student ID", value: "110433839")
                        InfoRow(label:  "Instiution", value: "University of South Australia")
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    
                    // Disclaimer
                    VStack(alignment: .leading, spacing: 15){
                        SectionHeader(title: "Disclaimer")
                        
                        Text("This application is created for educational purposes only as part of an iOS development assignment.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        Text("All bird images, names, and information are used for educational purposes. Image rights belong to their respective photographers and are licensed under various Creative Commons licenses.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        Text("This app is not intended for commercial use or distribution.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(15)
                    
                    // Copyright
                    VStack(spacing: 10){
                        Text("© 2025 Birdle")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Text("Educational Project")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                .navigationTitle("About")
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
}

// Section Header
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
    }
}

// Info Row
struct InfoRow: View{
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

// Feature Row
struct FeatureRow: View{
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15){
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    AboutView()
}
