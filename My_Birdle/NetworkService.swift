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
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let puzzle = try JSONDecoder().decode(BirdPuzzle.self, from: data)
                completion(.success(puzzle))
            } catch {
                completion(.failure(error))
            }
        }.resume()
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
