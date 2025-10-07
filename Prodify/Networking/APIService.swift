//
//  APIService.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//
//
//  APIService.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import Foundation

// MARK: - API Error Enum
enum APIError: Error, LocalizedError {
    case invalidURL
    case network(Error)
    case noResponse
    case server(Int)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Internal error. Please try again later."
        case .network(let err):
            return "Network error: \(err.localizedDescription)"
        case .noResponse:
            return "No response from server. Check your internet connection."
        case .server(let code):
            return "Server returned error code \(code). Please try later."
        case .decoding:
            return "Data error. Please update the app."
        }
    }
}

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func fetchProducts(page: Int, limit: Int, category: String,
                       completion: @escaping (Result<ProductResponse, APIError>) -> Void)
}

// MARK: - API Service Implementation
final class APIService: APIServiceProtocol {
    
    private let baseURL = "https://fakeapi.net/products"
    
    func fetchProducts(page: Int, limit: Int, category: String,
                       completion: @escaping (Result<ProductResponse, APIError>) -> Void) {
        
        print("Fetching products page: \(page), limit: \(limit), category: \(category)")
        
        // Build URL
        var comps = URLComponents(string: baseURL)!
        comps.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "category", value: category)
        ]
        
        guard let url = comps.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Request URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Network error
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion(.failure(.network(error)))
                return
            }
            
            // HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP response")
                completion(.failure(.noResponse))
                return
            }
            
            print("Status Code: \(httpResponse.statusCode)")
            
            guard (200..<300).contains(httpResponse.statusCode), let data = data else {
                print("Bad response or missing data")
                completion(.failure(.server(httpResponse.statusCode)))
                return
            }
            
            print("Received data (\(data.count) bytes)")
            
            // Optional: debug JSON string
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response:\n\(jsonString)")
            }
            
            // Decode
            do {
                let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                print("Decoded \(decoded.data.count) products successfully")
                completion(.success(decoded))
            } catch let decodeError {
                print("Decoding failed: \(decodeError.localizedDescription)")
                completion(.failure(.decoding(decodeError)))
            }
        }
        
        task.resume()
    }
}
