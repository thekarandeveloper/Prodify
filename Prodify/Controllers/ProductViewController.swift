//
//  ProductViewController.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Outlets
    @IBOutlet weak var productTableView: UITableView!
    
    
    // MARK: - ViewModel & Data
    
    private let viewModel = ProductsViewModel()
    private var filteredProducts: [Product] = []
    private var useRandomAssetImages: Bool = false {
        didSet { productTableView.reloadData() }
    }
    
    
    // MARK: - UI Components
    private let spinner = UIActivityIndicatorView(style: .large)
    private let footerSpinner = UIActivityIndicatorView(style: .medium)
    private let noDataLabel = UILabel()
    private let errorView = UIView()
    
    // MARK: - Search
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Prodify"
        setupTable()
        setupSpinnerAndNoData()
        setupSearchController()
        setupNavigationBarMenu()
        viewModel.delegate = self
        viewModel.loadInitial()
        print("Loaded products: \(viewModel.products.count)")
    }
    @objc private func retryTapped() {
        errorView.removeFromSuperview()
        viewModel.loadInitial()
    }
    // MARK: - Setup Functions
    private func setupTable() {
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.rowHeight = UITableView.automaticDimension
        productTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        productTableView.estimatedRowHeight = 100
        footerSpinner.frame = CGRect(x: 0, y: 0, width: productTableView.bounds.width, height: 44)
    }
    private func setupSpinnerAndNoData() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        noDataLabel.text = "No products found"
        noDataLabel.textAlignment = .center
        noDataLabel.isHidden = true
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataLabel)
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search products"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavigationBarMenu() {
        
        // Use SF Symbol for ellipsis
        let ellipsisImage = UIImage(systemName: "ellipsis.circle")
        
        // Menu toggle action
        let toggleAction = UIAction(title: "Show Local Images") { [weak self] _ in
            guard let self = self else { return }
            self.useRandomAssetImages.toggle()
            self.setupNavigationBarMenu() // refresh menu so the switch reflects state
        }
        
        toggleAction.state = useRandomAssetImages ? .on : .off
        
        let menu = UIMenu(title: "", options: .displayInline, children: [toggleAction])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: ellipsisImage,
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
        navigationItem.rightBarButtonItem?.menu = menu
    }
    
    private func showError(_ message: String) {
        let errView = UIView(frame: view.bounds)
        errView.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        let btn = UIButton(type: .system)
        btn.setTitle("Retry", for: .normal)
        btn.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        errView.addSubview(label); errView.addSubview(btn)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: errView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: errView.centerYAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: errView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: errView.trailingAnchor, constant: -24),
            
            btn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            btn.centerXAnchor.constraint(equalTo: errView.centerXAnchor)
        ])
        view.addSubview(errView)
        errorView.removeFromSuperview()
        errorView.frame = errView.frame
        errView.tag = 999
        errorView.addSubview(errView)
    }
    
    
}

// MARK: - UITableView DataSource
extension ProductViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredProducts.count : viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let product = isSearching ? filteredProducts[indexPath.row] : viewModel.products[indexPath.row]
        cell.configure(with: product, useRandomAsset: useRandomAssetImages)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UITableView Delegate
extension ProductViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextIfNeeded(currentIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = viewModel.products[indexPath.row]
        
        // Instantiate from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "productDetails") as? ProductDetailViewController {
            detailVC.product = product
            detailVC.shouldShowLocalAsset = useRandomAssetImages
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - ProductsViewModelDelegate
extension ProductViewController: ProductsViewModelDelegate {
    func viewModelDidStartLoading() {
        if viewModel.products.isEmpty {
            spinner.startAnimating()
        } else {
            footerSpinner.startAnimating()
            productTableView.tableFooterView = footerSpinner
        }
    }
    func viewModelDidEndLoading() {
        spinner.stopAnimating()
        footerSpinner.stopAnimating()
        productTableView.tableFooterView = nil
    }
    func viewModelDidUpdateProducts() {
        noDataLabel.isHidden = true
        productTableView.reloadData()
    }
    func viewModelDidFail(with error: Error) {
        if (error as? URLError)?.code == .notConnectedToInternet {
            showError("No internet connection.")
        } else {
            showError("Failed to load data. \(error.localizedDescription)")
        }
    }
    func viewModelNoData() {
        noDataLabel.isHidden = false
    }
}

// MARK: - UISearchResultsUpdating
extension ProductViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(), !text.isEmpty else {
            filteredProducts.removeAll()
            productTableView.reloadData()
            return
        }
        
        filteredProducts = viewModel.products.filter { $0.title.lowercased().contains(text) }
        productTableView.reloadData()
    }
}
