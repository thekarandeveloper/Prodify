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
            productImageView.layer.cornerRadius = 10
            productImageView.clipsToBounds = true
        }

        /// Configure cell with image
        
        func configure(with image: UIImage?) {
            productImageView.image = image
        }

        /// Configure cell with image URL (async load)
    func configure(product: Product) {
        productImageView.image = nil
        imageURL = product.image

        // Determine placeholder deterministically
        var placeholder: UIImage? = nil
        if true {
            let index = (product.id % 10) + 1    // IDs 0..n -> 1..10
            placeholder = UIImage(named: "\(index).png")
        }

        ImageLoader.shared.loadImage(
            id: product.id, from: product.image,
            placeholder: placeholder,
            showAssetImage: false // placeholder already set
        ) { [weak self] img in
            self?.productImageView.image = img
        }
    }

        override func prepareForReuse() {
            super.prepareForReuse()
            productImageView.image = nil
            imageURL = nil
        }
    
}
