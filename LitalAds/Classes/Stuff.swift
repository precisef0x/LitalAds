//
//  Stuff.swift
//  LitalAds
//
//  Created by Onee Chan on 15/06/2020.
//

import Foundation
import Security
import CommonCrypto

class KeyChain {
    class func save(key: String, data: Data) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
        
        let swiftString: String = cfStr as String
        return swiftString
    }
}

extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

func pleaseDispatchMainAsyncAfter(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func pleaseDispatchMainSync(execute block: () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}

func pleaseDispatchMainAsync(execute block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

func pleaseDispatchAsync(execute block: @escaping () -> Void) {
    DispatchQueue(label: "com.app.randomQueue", qos: .background, target: nil).async {
        block()
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

func generateRandomData(length: Int) -> Data {
    var randomBytes = [UInt8](repeating: 0, count: length)
    let _ = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
    return Data(bytes: randomBytes, count: length)
}

extension String {
    static func randomHash() -> String {
        let length = 32
        var randomBytes = [UInt8](repeating: 0, count: length)
        let _ = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
        let data = Data(bytes: randomBytes, count: length)
        return (digest(input: data as NSData) as Data).hexadecimal
    }
    
    static func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
}

extension Data {
    var hexadecimal: String {
        return map { String(format: "%02x", $0) }
            .joined()
    }
}
