//
//  Product.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let image: URL?
}

// Models/ProductResponse.swift
struct ProductResponse: Codable {
    let products: [Product]
    let nextPage: Int?
}
