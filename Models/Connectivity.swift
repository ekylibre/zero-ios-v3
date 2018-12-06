//
//  Connectivity.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation
import SystemConfiguration

class Connectivity {

  class func setupDefaultRouteRachability(_ zeroAddress: inout sockaddr_in) -> SCNetworkReachability? {
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }

    return defaultRouteReachability
  }

  class func internetIsReachable(_ flags: SCNetworkReachabilityFlags) -> Bool {
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0

    return (isReachable && !needsConnection)
  }

  class func isConnectedToInternet() -> Bool {
    var flags = SCNetworkReachabilityFlags()
    var zeroAddress = sockaddr_in()

    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    if let defaultRouteReachability = setupDefaultRouteRachability(&zeroAddress) {
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
      }
    }
    return internetIsReachable(flags)
  }
}
