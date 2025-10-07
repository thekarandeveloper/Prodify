//
//  APIService.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import Foundation

protocol APIServiceProtocol {
    func fetchProducts(page: Int, limit: Int, category: String,
                       completion: @escaping (Result<ProductResponse, Error>) -> Void)
}

final class APIService: APIServiceProtocol {
    private let base = "https://fakeapi.net/products"

    func fetchProducts(page: Int, limit: Int, category: String,
                       completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        var comps = URLComponents(string: base)!
        comps.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "category", value: category)
        ]
        guard let url = comps.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err {
                completion(.failure(err)); return
            }
            guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode),
                  let data = data else {
                completion(.failure(NSError(domain: "BadResponse", code: -1))); return
            }
            do {
                let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
