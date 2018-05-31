import Foundation
import UIKit
import SystemConfiguration

final class OfflineModeManager {
    
    static public let s = OfflineModeManager()
    private init() {
        offlineMode = !isConnectedToNetwork()
    }
    
    private(set) var offlineMode = true
    
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
        } ) else {
            return false
        }
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {return false}
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    public func on() {
        offlineMode = true
        AuthManager.s.setAuthWindow()
    }
    
    public func off() {
        guard isConnectedToNetwork() else { return }
        offlineMode = false
        AuthManager.s.setAuthWindow()
    }
    
}
