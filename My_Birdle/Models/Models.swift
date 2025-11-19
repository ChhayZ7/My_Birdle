//
//  Models.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 6/11/2025.
//

import Foundation

struct BirdPuzzle: Codable, Identifiable {
    let name: String
    let image: String // 4-digit code like "0008"
    let photographer: String
    let license: String
    let photographer_link: String
    let bird_link: String
    
    var id: String { image } // Use image code as ID
    
    enum CodingKeys: String, CodingKey {
        case name
        case image
        case photographer
        case license
        case photographer_link = "photographer_url"
        case bird_link = "bird_url"
    }
    
    // Generate image URLs from the 4-digit code
    var imageURLs: [String] {
        return (0...5).map {
            index in "https://easterbilby.net/birdle/\(image)\(index).jpg"
        }
    }
    
    // Final reveal image (index 5)
    var finalImageURL: String {
        "https://easterbilby.net/birdle/\(image)5.jpg"
    }
}

// Bird Names List Response
struct BirdNamesResponse: Codable {
    let date: String
    let birds: [String]
}

// API Error Response
struct APIErrorResponse: Codable {
    let result: String // "error"
}

// API Success Response
struct APISuccessResponse: Codable {
    let result: String // "success"
}

// License Types
enum ImageLicense: String, CaseIterable {
    case publicDomain = "Public Domain"
    case ccBy = "CC BY"
    case ccBySa = "CC BY-SA"
    case ccByNc = "CC BY-NC"
    case ccByNcSa = "CC BY-NC-SA"
    case ccByNcNd = "CC BY-NC-ND"
}

// Puzzle Attempt Result
struct PuzzleResult {
    let birdName: String
    let attempts: Int
    let timeSpent: TimeInterval
    let date: Date
    let imageUrl: String
    let photographer: String
    let license: String
    let wikiLink: String
}
