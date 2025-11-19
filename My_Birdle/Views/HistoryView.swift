//
//  HistoryView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 11/11/2025.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    // Core Data Fetch Request
    // Automatically fetches and updates when data changes
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PuzzleHistory.completionDate, ascending: false)],
        animation: .default)
    private var history: FetchedResults<PuzzleHistory>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if history.isEmpty {
                    EmptyHistoryView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(history){ item in
                                HistoryCard(item: item)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done"){
                        dismiss()
                    }
                }
            }
        }
    }
}

// Empty History View
struct EmptyHistoryView: View{
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "clock.badge.questionmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.gray)
            
            Text("No History Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Complete your first puzzle to see it here!")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// History Card
// Displays completed puzzle details
struct HistoryCard: View {
    let item: PuzzleHistory
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            // Header with date and result
            HStack{
                VStack(alignment: .leading, spacing: 4){
                    Text(item.birdName ?? "Unkown Bird")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if let date = item.completionDate{
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                ResultBadge(attempts: Int(item.attempts))
            }
            
            // Bird image
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 150)
                    .cornerRadius(10)
                    .overlay(
                        ProgressView()
                    )
            }
            
            // Stats
            HStack(spacing: 20){
                StatItem(
                    icon: "target",
                    label: "Attempts",
                    value: "\(item.attempts)/5"
                )
                
                StatItem(
                    icon: "clock",
                    label: "Time",
                    value: formatTime(item.timeSpent)
                )
                Spacer()
            }
            
            // Additional info
            VStack(alignment: .leading, spacing: 4){
                if let photographer = item.photographer {
                    HStack {
                        Image(systemName: "camera.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(photographer)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let license = item.license {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(license)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Link to more info
            if let wikiLink = item.wikiLink, let url = URL(string: wikiLink) {
                Link(destination: url){
                    HStack {
                        Image(systemName: "link.circle.fill")
                        Text("Learn More")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .font(.subheadline)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            loadImage()
        }
    }
    
    // Image loading method
    private func loadImage() {
        guard let urlString = item.imageUrl else { return }
        
        NetworkService.shared.downloadImage(from: urlString) { result in
            if case .success(let downloadedImage) = result {
                DispatchQueue.main.async {
                self.image = downloadedImage
                }
            } else {
                // Use placeholder if download fails
                self.image = createPlaceholder()
            }
        }
    }
    
    // Create placeholder bird icon
    private func createPlaceholder() -> UIImage {
        let size = CGSize(width: 400, height: 400)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.systemGray5.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let iconConfig = UIImage.SymbolConfiguration(pointSize: 80, weight: .light)
            if let icon = UIImage(systemName: "bird.fill", withConfiguration: iconConfig) {
                let iconRect = CGRect(
                    x: (size.width - 100) / 2,
                    y: (size.height - 100) / 2,
                    width: 100,
                    height: 100
                )
                UIColor.systemGray.setFill()
                icon.draw(in: iconRect)
            }
        }
    }
    
    private func formatTime(_ seconds: Double) -> String{
        let minutes = Int(seconds) / 60
        let sec = Int(seconds) & 60
        return String(format: "%02d:%02d", minutes, sec)
    }
}

// Result badge
// Shows success/failure status
struct ResultBadge: View {
    let attempts: Int
    
    var isSuccess: Bool {
        attempts <= 5
    }
    
    var body: some View {
        HStack(spacing: 5){
            Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isSuccess ? .green : .orange)
            Text("\(attempts)/5")
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isSuccess ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
        .cornerRadius(20)
    }
}

// State Item
struct StatItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            HStack(spacing: 4){
                Image(systemName: icon)
                    .font(.caption)
                Text(label)
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    HistoryView()
}
