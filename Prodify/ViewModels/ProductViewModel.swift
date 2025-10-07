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
        guard !isLoading else { return }
        isLoading = true
        delegate?.viewModelDidStartLoading()

        service.fetchProducts(page: page, limit: limit, category: category) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.delegate?.viewModelDidEndLoading()
                switch result {
                case .success(let resp):
                    if page == 0 { self.products = resp.products }
                    else { self.products.append(contentsOf: resp.products) }
                    self.nextPage = resp.nextPage
                    if self.products.isEmpty { self.delegate?.viewModelNoData() }
                    else { self.delegate?.viewModelDidUpdateProducts() }
                case .failure(let err):
                    self.delegate?.viewModelDidFail(with: err)
                }
            }
        }
    }
}
