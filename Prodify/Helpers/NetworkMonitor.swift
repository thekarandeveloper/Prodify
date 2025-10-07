//
//  NetworkMonitor.swift
//  Prodify
//
//  Created by Karan Kumar on 07/10/25.
//
import Foundation
import Network
import UIKit

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = false
    var onStatusChanged: ((Bool) -> Void)?
    
    private var lastUpdateTime = Date()
    private var stuckCheckTimer: Timer?
    
    private init() {
        startMonitoring()
        startStuckDetection()
    }
    
    private func startMonitoring() {
        print("Starting monitor")
        
        // Cancel old monitor
        monitor?.cancel()
        
        // Create new monitor
        let newMonitor = NWPathMonitor()
        monitor = newMonitor
        
        // Get initial status
        isConnected = newMonitor.currentPath.status != .unsatisfied
        print("Initial status: \(isConnected)")
        
        newMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            self.lastUpdateTime = Date()
            
            let connected = path.status == .satisfied
            
            print("Network update:")
            print("Status: \(path.status)")
            print("Connected: \(connected)")
            print("Interfaces: \(path.availableInterfaces.count)")
            
            // List interfaces
            for interface in path.availableInterfaces {
                print("   - \(interface.name): \(interface.type)")
            }
            
            DispatchQueue.main.async {
                if self.isConnected != connected {
                    print("Status CHANGED: \(self.isConnected) → \(connected)")
                    self.isConnected = connected
                    self.onStatusChanged?(connected)
                } else {
                    print("Status same: \(connected)")
                }
            }
        }
        
        newMonitor.start(queue: queue)
        print("Monitor started")
    }
    
    // Detect if monitor is stuck
    private func startStuckDetection() {
        stuckCheckTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // If no updates in 10 seconds, restart
            let timeSinceUpdate = Date().timeIntervalSince(self.lastUpdateTime)
            if timeSinceUpdate > 10 {
                print("Monitor stuck! Restarting...")
                self.restartMonitor()
            }
        }
    }
    
    private func restartMonitor() {
        print("Restarting monitor due to stuck state")
        startMonitoring()
        
        // Force check after restart
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.forceCheck()
        }
    }
    
    func forceCheck() {
        guard let monitor = monitor else { return }
        
        let currentPath = monitor.currentPath
        let connected = currentPath.status == .satisfied
        
        print("Force check:")
        print("   Current path status: \(currentPath.status)")
        print("   Connected: \(connected)")
        print("   Interfaces: \(currentPath.availableInterfaces.count)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.isConnected != connected {
                print("Force changed: \(self.isConnected) → \(connected)")
                self.isConnected = connected
                self.onStatusChanged?(connected)
            }
        }
    }
    
    deinit {
        stuckCheckTimer?.invalidate()
        monitor?.cancel()
    }
}
