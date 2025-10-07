//
//  ProductDetailViewController.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class ProductDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var product: Product!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var productDetailsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = product.title
        setupTableView()
        setupButton()
        
    }

    private func setupTableView() {
        productDetailsTableView.dataSource = self
        productDetailsTableView.delegate = self
        productDetailsTableView.register(UINib(nibName: "ProductImageTableViewCell", bundle: nil), forCellReuseIdentifier: "productImage")
        productDetailsTableView.register(UINib(nibName: "ProductDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "productDetails")
    }
    private func setupButton(){
        buyButton.setTitle("Buy \(product.price)", for: .normal)
    }
}

extension ProductDetailViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            // Image cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "productImage", for: indexPath) as? ProductImageTableViewCell else {
                return UITableViewCell()
            }
            
            if let url = product.image {
                cell.configure(with: url)
            } else {
                cell.configure(with: UIImage(named: "claude"))
            }
            cell.configure(with: UIImage(named: "claude"))
            return cell
            
        } else {
            
            // Details cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "productDetails", for: indexPath) as? ProductDetailsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: product)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else{
            return 200
        }
    }
    
    
    
}
