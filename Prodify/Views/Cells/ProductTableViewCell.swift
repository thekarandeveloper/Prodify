//
//  ProductTableViewCell.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cardBody: UIView!
    
    private var imageURL: URL?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Make image view rounded or proper content mode
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        // Optional: rounded corners for cell
        layer.cornerRadius = 8
        layer.masksToBounds = true

    }

    func configure(with product: Product, useRandomAsset: Bool = true) {
        titleLabel.text = product.title
        descLabel.text = product.description
        categoryLabel.text = product.category.capitalized
        priceLabel.text = "₹\(product.price)"

        // Reset previous image
        productImageView.image = nil
        imageURL = nil

        // Set image if URL exists
        ImageLoader.shared.loadImage(
            id: product.id, from: product.image,
                placeholder: UIImage(named: "placeholder"),
                showAssetImage: useRandomAsset
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
