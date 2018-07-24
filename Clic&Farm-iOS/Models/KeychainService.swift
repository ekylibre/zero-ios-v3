//
//  SaveAccount.swift
//  ClickAndFarm-IOS
//
//  Created by Jonathan DE HAAY on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class KeychainService: NSObject {

    class func save(key: String, data: NSData) {
        let query = [kSecClass as String: kSecClassGenericPassword as String, kSecAttrAccount as String: key, kSecValueData as String: data] as [String: Any]

        SecItemDelete(query as CFDictionary)
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            if let err = SecCopyErrorMessageString(status, nil) {
                print("Saving failed: \(err)")
            }
        }
    }

    class func load(key: String) -> NSData? {
        let query = [kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: key, kSecReturnData as String  : kCFBooleanTrue, kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return (dataTypeRef! as! NSData)
        } else {
            return nil
        }
    }

    class func stringToNSDATA(string: String) -> NSData {
        let _Data = (string as NSString).data(using: String.Encoding.utf8.rawValue)

        return _Data! as NSData
    }

    class func NSDATAtoString(data: NSData) -> String {
        let returned_string: String = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String

        return returned_string
    }
}
