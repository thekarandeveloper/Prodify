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
    @IBOutlet weak var categoryLabel: UIButton!

    private var imageURL: URL?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Make image view rounded or proper content mode
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true

        // Optional: rounded corners for cell
        layer.cornerRadius = 8
        layer.masksToBounds = true

        // Debug
        print("✅ ProductTableViewCell awakeFromNib called")
    }

    func configure(with product: Product) {
        titleLabel.text = product.title
        descLabel.text = product.description
        categoryLabel.setTitle(product.category, for: .normal)
        priceLabel.text = "₹\(product.price)"

        // Optional: print product info for debug
        print("📝 Configuring cell with product:", product.title)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        imageURL = nil
    }
}
