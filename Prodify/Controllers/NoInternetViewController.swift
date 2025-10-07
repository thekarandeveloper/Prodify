//
//  NoInternetViewController.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//

import UIKit
import Network

class NoInternetViewController: UIViewController {

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitor")
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Setup activity indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    @IBAction func retryButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
             checkInternetConnection()
         }
         
         private func checkInternetConnection() {
             monitor.pathUpdateHandler = { [weak self] path in
                 DispatchQueue.main.async {
                     if path.status == .satisfied {
                         print("✅ Internet is back")
                         self?.internetRestored()
                     } else {
                         print("❌ Still no internet")
                         // Keep activity indicator running
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
         
         deinit {
             monitor.cancel()
         }
     }
