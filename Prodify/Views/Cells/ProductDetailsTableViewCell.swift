//
//  ProductDetailsTableViewCell.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class ProductDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with product: Product) {
           productName.text = product.title
        productCategory.text = product.category.capitalized
        productDescription.text = product.description
    }
       
       override func prepareForReuse() {
           super.prepareForReuse()
           productName.text = nil
           productCategory.text = nil
           productDescription.text = nil
       }
}
