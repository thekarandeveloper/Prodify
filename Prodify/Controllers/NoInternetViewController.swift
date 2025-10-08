//
//  NoInternetViewController.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit
import Network

class NoInternetViewController: UIViewController {
    
    // MARK: - Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitor")
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "No Internet"
        view.backgroundColor = .systemBackground
        setupActivtiyIndicator()
    }
    deinit {
        monitor.cancel()
    }
    
    
    // MARK: - Setup Methods
    private func setupActivtiyIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Actions
    @IBAction func retryButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        checkInternetConnection()
    }
    
    // MARK: - Internet Check
    private func checkInternetConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("Internet is back")
                    self?.internetRestored()
                } else {
                    print("Still no internet")
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func internetRestored() {
        activityIndicator.stopAnimating()
        self.dismiss(animated: true)
        monitor.cancel()
    }
    
}
