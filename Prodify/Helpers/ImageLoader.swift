//
//  ImageLoader.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private var tasks = [NSURL: URLSessionDataTask]()

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let ns = url as NSURL
        if let img = cache.object(forKey: ns) {
            completion(img); return
        }
        if tasks[ns] != nil { return } // already loading

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, resp, err in
            defer { self?.tasks[ns] = nil }
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }; return
            }
            self?.cache.setObject(image, forKey: ns)
            DispatchQueue.main.async { completion(image) }
        }
        tasks[ns] = task
        task.resume()
    }

    func cancelLoading(url: URL) {
        let ns = url as NSURL
        tasks[ns]?.cancel()
        tasks[ns] = nil
    }
}
