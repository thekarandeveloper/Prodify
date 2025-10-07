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

        // Reset previous image
        productImageView.image = nil
        imageURL = nil

        // Set image if URL exists
        if let url = product.image {
            imageURL = url
            print("🌐 Loading image from:", url)
            
            // Using URLSession directly
            URLSession.shared.dataTask(with: url) { [weak self] data, _, err in
                guard let self = self else { return }
                if let data = data, let img = UIImage(data: data) {
                    // Ensure this cell is still displaying same URL
                    if self.imageURL == url {
                        DispatchQueue.main.async {
                            self.productImageView.image = img
                        }
                    }
                } else if let err = err {
                    print("❌ Failed to load image:", err)
                }
            }.resume()
        }
        
        productImageView.image = UIImage(named: "claude")
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        imageURL = nil
    }
}
