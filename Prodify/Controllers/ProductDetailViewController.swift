//
//  ProductDetailViewController.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    private let product: Product
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = product.title
        setupUI()
    }

    private func setupUI() {
        let imageView = UIImageView()
        let desc = UILabel()
        desc.numberOfLines = 0
        desc.text = product.description
        let price = UILabel()
        price.text = "₹\(product.price)"
        // layout minimally
        imageView.translatesAutoresizingMaskIntoConstraints = false
        desc.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView); view.addSubview(desc); view.addSubview(price)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            price.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            desc.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 8),
            desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        if let url = product.image {
            ImageLoader.shared.loadImage(from: url) { image in
                imageView.image = image
            }
        }
    }
}
