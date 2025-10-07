//
//  ProductViewModel.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import Foundation

protocol ProductsViewModelDelegate: AnyObject {
    func viewModelDidStartLoading()
    func viewModelDidEndLoading()
    func viewModelDidUpdateProducts()
    func viewModelDidFail(with error: Error)
    func viewModelNoData()
}

final class ProductsViewModel {
    private let service: APIServiceProtocol
    weak var delegate: ProductsViewModelDelegate?

    private(set) var products = [Product]()
    private(set) var nextPage: Int? = 0
    private var isLoading = false
    private let limit = 10
    private let category = "electronics"

    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }

    func loadInitial() {
        nextPage = 0
        products.removeAll()
        load(page: 0)
    }

    func loadNextIfNeeded(currentIndex: Int) {
        guard !isLoading, let next = nextPage else { return }
        if currentIndex >= products.count - 3 { load(page: next) }
    }

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
                case .success(let resp):
                    if page == 0 {
                        self.products = resp.data
                    } else {
                        self.products.append(contentsOf: resp.data)
                    }

                    // Determine nextPage
                    if resp.pagination.page * resp.pagination.limit < resp.pagination.total {
                        self.nextPage = resp.pagination.page
                    } else {
                        self.nextPage = nil
                    }

                    if self.products.isEmpty {
                        self.delegate?.viewModelNoData()
                    } else {
                        self.delegate?.viewModelDidUpdateProducts()
                    }

                case .failure(let err):
                    print("❌ Failed to fetch products: \(err.localizedDescription)")
                    self.delegate?.viewModelDidFail(with: err)
                }
            }
        }
    }
}
