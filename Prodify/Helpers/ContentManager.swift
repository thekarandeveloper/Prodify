//
//  ContentManager.swift
//  Prodify
//
//  Created by Karan Kumar on 08/10/25.
//


import UIKit

final class ContentManager {
    
    static let shared = ContentManager()
    private init() {}
    
    
    // MARK: - Storyboards
    struct Storyboards {
        let main = "Main"
    }
    let storyboards = Storyboards()
    
    
    // MARK: - Nibs
    struct Nibs {
        let ProductTableViewCell = "ProductTableViewCell"
        let ProductImageTableViewCell = "ProductImageTableViewCell"
        let ProductDetailsTableViewCell = "ProductDetailsTableViewCell"
    }
    let nibs = Nibs()
    
    // MARK: - Reuse Identifiers
    struct ReuseIdentifiers {
        let productCell = "ProductCell"
        let imageCell = "productImage"
        let detailsCell = "productDetails"
        let detailController = "ProductDetails"
    }
    let reuse = ReuseIdentifiers()
    
    // MARK: - Placeholders
    struct Placeholders {
        let productImage = "placeholder"
    }
    let placeholders = Placeholders()
    
    // MARK: - Messages
    struct Messages {
        let taskQueueLabel = "InternetMonitor"
        let noProductFound = "No products found"
        let noInternet = "No internet connection."
        let internetIsBack = "Internet is Back."
        let retry = "Retry"
        let failedToLoad = "Failed to Load"
       
    }
    let messages = Messages()
    
    // MARK: - Titles
    struct Titles {
        let appName = "Prodify"
        let searchPlaceholder = "Search products"
        let buyButtonPrefix = "Buy $"
        let localImageToggleMenu = "Fallback to local images if API image is missing."
        let showLocalImages = "Show Local Images"
    }
    let titles = Titles()
    
    // MARK: - Other Static Content
    struct Images {
        let ellipsis = UIImage(systemName: "ellipsis.circle")
    }
    let images = Images()
}
