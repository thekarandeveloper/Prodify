//
//  ProductImageTableViewCell.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class ProductImageTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    private var imageURL: URL?

        override func awakeFromNib() {
            super.awakeFromNib()
            // Make image view scale nicely
            productImageView.contentMode = .scaleAspectFill
            productImageView.clipsToBounds = true
        }

        /// Configure cell with image
        /// - Parameter image: Either a local UIImage or nil
        func configure(with image: UIImage?) {
            productImageView.image = image
        }

        /// Configure cell with image URL (async load)
        func configure(with url: URL?) {
            productImageView.image = nil
            imageURL = url

            guard let url = url else { return }

            // Simple async image loading
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self,
                      let data = data,
                      let img = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    // Make sure cell hasn't been reused for another URL
                    if self.imageURL == url {
                        self.productImageView.image = img
                    }
                }
            }.resume()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            productImageView.image = nil
            imageURL = nil
        }
    
}
