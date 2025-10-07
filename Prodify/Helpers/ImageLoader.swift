//
//  ImageLoader.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private var runningRequests = [URL: URLSessionDataTask]()

    private init() {}

    func loadImage(id:Int, from url: URL?,
                   placeholder: UIImage? = UIImage(named: "placeholder"),
                   showAssetImage: Bool = false,
                   completion: @escaping (UIImage?) -> Void) {

        // Random Image Logic
        if showAssetImage {
            let index = (id % 10) + 1    // IDs 0..n -> 1..10
            let assetImage = UIImage(named: "\(index).png")
            completion(assetImage)
            return
        }

        // Show placeholder immediately
        completion(placeholder)

        guard let url = url else { return }

        // Avoid duplicate requests
        if let _ = runningRequests[url] { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            defer { self?.runningRequests.removeValue(forKey: url) }
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        runningRequests[url] = task
        task.resume()
    }

    func cancelLoading(url: URL) {
        runningRequests[url]?.cancel()
        runningRequests.removeValue(forKey: url)
    }
}
