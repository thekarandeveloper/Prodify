//
//  ProductDetailViewController.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class ProductDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Outlets
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var productDetailsTableView: UITableView!
    
    
    // MARK: - Properties
    var product: Product!
    var shouldShowLocalAsset: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = product.title
        setupTableView()
        setupButton()
        
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        productDetailsTableView.dataSource = self
        productDetailsTableView.delegate = self
        productDetailsTableView.register(UINib(nibName: ContentManager.shared.nibs.ProductImageTableViewCell, bundle: nil), forCellReuseIdentifier: ContentManager.shared.reuse.imageCell)
        productDetailsTableView.register(UINib(nibName: ContentManager.shared.nibs.ProductDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: ContentManager.shared.reuse.detailsCell)
    }
    private func setupButton(){
        buyButton.setTitle("\(ContentManager.shared.titles.buyButtonPrefix)\(product.price)", for: .normal)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentManager.shared.reuse.imageCell, for: indexPath) as? ProductImageTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(product:product, showLocalAsset: shouldShowLocalAsset)
            
            return cell
            
        } else {
            
            // Details cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentManager.shared.reuse.detailsCell, for: indexPath) as? ProductDetailsTableViewCell else {
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
