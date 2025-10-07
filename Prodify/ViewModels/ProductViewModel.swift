//
//  ProductViewModel.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//


import Foundation

// MARK: - ViewModel Delegate
protocol ProductsViewModelDelegate: AnyObject {
    func viewModelDidStartLoading()
    func viewModelDidEndLoading()
    func viewModelDidUpdateProducts()
    func viewModelDidFail(with error: Error)
    func viewModelNoData()
}

// MARK: - ViewModel
final class ProductsViewModel {
    
    private let service: APIServiceProtocol
    weak var delegate: ProductsViewModelDelegate?
    
    private(set) var products = [Product]()
    private(set) var nextPage: Int? = 0
    private var isLoading = false
    private let limit = 10
    private let category = "electronics"
    
    // MARK: - Init
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }
    
    // MARK: - Load Initial Data
    func loadInitial() {
        nextPage = 0
        products.removeAll()
        load(page: 0)
    }
    
    // MARK: - Load Next Page if Needed
    func loadNextIfNeeded(currentIndex: Int) {
        guard !isLoading, let next = nextPage else { return }
        if currentIndex >= products.count - 3 {
            load(page: next)
        }
    }
    
    // MARK: - Private Load Function
    private func load(page: Int) {
        guard !isLoading else {
            print("⚠️ Already loading, skipping page \(page)")
            return
        }
        
        isLoading = true
        print("🔄 Starting fetch for page: \(page)")
        delegate?.viewModelDidStartLoading()
        
        service.fetchProducts(page: page, limit: limit, category: category) { [weak self] result in
            guard let self = self else {
                print("❌ Self deallocated before fetch completed.")
                return
            }
            
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.delegate?.viewModelDidEndLoading()
                print("✅ Finished network call for page: \(page)")
                
                switch result {
                    
                case .success(let response):
                    // Append or replace products
                    if page == 0 {
                        self.products = response.data
                    } else {
                        self.products.append(contentsOf: response.data)
                    }
                    
                    // Determine nextPage
                    let totalLoaded = (response.pagination.page) * response.pagination.limit
                    if totalLoaded < response.pagination.total {
                        self.nextPage = response.pagination.page
                    } else {
                        self.nextPage = nil
                    }
                    
                    // Update UI via delegate
                    if self.products.isEmpty {
                        self.delegate?.viewModelNoData()
                        print("⚠️ No products found.")
                    } else {
                        self.delegate?.viewModelDidUpdateProducts()
                        print("📦 Total products loaded:", self.products.count)
                    }
                    
                case .failure(let apiError):
                    // Pass error to delegate
                    self.delegate?.viewModelDidFail(with: apiError)
                    print("❌ Failed to fetch products:", apiError.localizedDescription)
                }
            }
        }
    }
}
