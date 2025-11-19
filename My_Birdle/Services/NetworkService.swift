//
//  NetworkService.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 6/11/2025.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "https://easterbilby.net/birdle/api.php?"
    private let imageBaseURL = "https://easterbilby.net/birdle/"
    
    private init(){}
    
    func fetchDailyPuzzle(completion: @escaping (Result<BirdPuzzle, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
            request.timeoutInterval = 30.0
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            print("API Response", String(data: data, encoding: .utf8) ?? "nil")
            do {
                let puzzle = try JSONDecoder().decode(BirdPuzzle.self, from: data)
                completion(.success(puzzle))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Fetch Specific Puzzle
    func fetchPuzzle(id: Int, completion: @escaping (Result<BirdPuzzle, Error>) -> Void){
        guard let url = URL(string: "\(baseURL)action=download&id=\(id)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Check for error response first
                if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
                   errorResponse.result == "error" {
                    completion(.failure(NetworkError.serverError))
                    return
                }
                
                let puzzle = try JSONDecoder().decode(BirdPuzzle.self, from: data)
                completion(.success(puzzle))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    // Fetch Bird Names
    func fetchBirdNames(completion: @escaping (Result<[String], Error>) -> Void){
        guard let url = URL(string: "\(baseURL)action=list") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BirdNamesResponse.self, from: data)
                completion(.success(response.birds))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Download Image
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void){
    guard let url = URL(string: urlString) else {
        completion(.failure(NetworkError.invalidURL))
        return
    }

    URLSession.shared.dataTask(with: url){ data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data, let image = UIImage(data: data) else {
            completion(.failure(NetworkError.invalidImageData))
            return
        }
        
        completion(.success(image))
    }.resume()
    }
    
    // Upload Bird Image
    func uploadBirdImage(
        name: String,
        image: UIImage,
        photographerName: String,
        license: String,
        photographerLink: String,
        birdLink: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)action=upload") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Convert image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NetworkError.invalidImageData))
            return
        }
        
        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add name
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n")
        body.append("\(name)\r\n")
        
        // Add photographer_name
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"photographer_name\"\r\n\r\n")
        body.append("\(photographerName)\r\n")
        
        // Add license
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"license\"\r\n\r\n")
        body.append("\(license)\r\n")
        
        // Add photographer_link
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"photographer_link\"\r\n\r\n")
        body.append("\(photographerLink)\r\n")
        
        // Add bird_link
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"bird_link\"\r\n\r\n")
        body.append("\(birdLink)\r\n")
        
        // Add image
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"bird.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append((imageData))
        body.append("\r\n")
        
        // Close boundary
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        // Check if body contains actual image data (not text)
        let bodyAsString = String(data: body.prefix(1000), encoding: .utf8) ?? ""
        if bodyAsString.contains("bytes") {
            print("⚠️ WARNING: Image might be text, not binary!")
        } else {
            print("✅ Image appears to be binary data")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            print("data: ", data)
            
            // Check for successs response
            if let successResponse = try? JSONDecoder().decode(APISuccessResponse.self, from: data),
               successResponse.result == "success" {
                completion(.success(true))
            } else {
                completion(.failure(NetworkError.serverError))
            }
        }.resume()
    }

}

// Data Extension
extension Data {
    mutating func append(_ string: String){
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case invalidImageData
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data returned"
        case .invalidImageData:
            return "Invalid image data"
        case .serverError:
            return "Server error"
        }
    }
}
