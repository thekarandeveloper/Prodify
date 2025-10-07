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
        print("🔄 Starting fetch for page: \(page), limit: \(limit), category: \(category)")

        var comps = URLComponents(string: base)!
        comps.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "category", value: category)
        ]

        guard let url = comps.url else {
            print("❌ Invalid URL components:", comps)
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        print("🌐 Final Request URL:", url.absoluteString)

        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err {
                print("🚫 Network Error:", err.localizedDescription)
                completion(.failure(err))
                return
            }

            guard let http = resp as? HTTPURLResponse else {
                print("⚠️ No HTTP response received")
                completion(.failure(NSError(domain: "NoHTTPResponse", code: -1)))
                return
            }

            print("📡 Response Status Code:", http.statusCode)

            guard (200..<300).contains(http.statusCode), let data = data else {
                print("❌ Bad response or missing data.")
                if let data = data, let str = String(data: data, encoding: .utf8) {
                    print("⚠️ Response body:", str)
                }
                completion(.failure(NSError(domain: "BadResponse", code: http.statusCode)))
                return
            }

            print("📦 Raw response data received (\(data.count) bytes)")

            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON Response:\n\(jsonString)")
            } else {
                print("⚠️ Could not convert response data to String.")
            }

            do {
                let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                print("✅ Successfully decoded ProductResponse with \(decoded.data.count) products.")
                completion(.success(decoded))
            } catch {
                print("❌ Decoding failed:", error.localizedDescription)
                print("🔍 Error Type:", type(of: error))
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
