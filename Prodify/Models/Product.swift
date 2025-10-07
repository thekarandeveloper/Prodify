//
//  Product.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import Foundation
struct ProductResponse: Codable {
    let data: [Product]
    let pagination: Pagination
}

struct Pagination: Codable {
    let page: Int
    let limit: Int
    let total: Int
}

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let brand: String?
    let stock: Int?
    let image: URL?
    // Optional: specs and rating
    let specs: [String: CodableValue]?
    let rating: Rating?
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}

// Helper for dynamic/spec dictionary
struct CodableValue: Codable {}
