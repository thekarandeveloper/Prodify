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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
    }
    required init?(coder: NSCoder) { fatalError() }

    
    func configure(with product: Product) {
            titleLabel.text = product.title
            descLabel.text = product.description
            categoryLabel.setTitle(product.category, for: .normal)
            priceLabel.text = "₹\(product.price)"
            productImageView.image = nil

            if let url = product.image {
                imageURL = url
                ImageLoader.shared.loadImage(from: url) { [weak self] img in
                    guard let self = self else { return }
                    if self.imageURL == url { self.productImageView.image = img }
                }
            } else {
                imageURL = nil
                productImageView.image = nil
            }
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            if let url = imageURL { ImageLoader.shared.cancelLoading(url: url) }
            imageURL = nil
            productImageView.image = nil
        }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
