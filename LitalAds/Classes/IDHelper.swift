//
//  IDHelper.swift
//  LitalAds
//
//  Created by Onee Chan on 15/06/2020.
//

import Foundation
import GameKit
import AdSupport
import Security

class IDHelper {
    static let shared = IDHelper()
    
    private init() {
        
    }
    
    func initAppID() {
        if KeyChain.load(key: "litalAppID") == nil {
            let hash = String.randomHash()
            KeyChain.save(key: "litalAppID", data: Data.init(from: hash))
        }
    }
    
    func adsId() -> String? {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return nil
    }
    
    func getIDs(completion: @escaping (_ appId: String?, _ adsId: String?, _ gcId: String?, _ deviceName: String?, _ iosVersion: String?, _ model: String?) -> Void) {
        let deviceName = UIDevice.current.name
        let iosVersion = UIDevice.current.systemVersion
        var model: String? = UIDevice.current.model
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        model = identifier
        
        var appId: String? = nil
        
        if let idData = KeyChain.load(key: "litalAppID") {
            if let idString = String(data: idData, encoding: .utf8) {
                appId = idString
            }
        }
        
        self.getUniqueIDs { (adsId, gcId) in
            completion(appId, adsId, gcId, deviceName, iosVersion, model)
        }
    }
    
    func getUniqueIDs(completion: @escaping (_ adsId: String?, _ gcId: String?) -> Void) {
        pleaseDispatchAsync {
            let localPlayer = GKLocalPlayer.local
            
            if localPlayer.playerID != "" {
                completion(self.adsId(), localPlayer.playerID)
            } else {
                localPlayer.authenticateHandler = {(viewController : UIViewController!, error : Error!) -> Void in
                    if viewController != nil {
                        if let currentVC = UIApplication.topViewController() {
                            pleaseDispatchMainAsync {
                                currentVC.present(viewController, animated: true) {
                                    IDHelper.shared.getUniqueIDs { (adsId, gcId) in
                                        completion(adsId, gcId)
                                    }
                                }
                            }
                        } else {
                            completion(self.adsId(), nil)
                        }
                    } else {
                        if localPlayer.isAuthenticated {
                            completion(self.adsId(), localPlayer.playerID)
                        } else {
                            completion(self.adsId(), nil)
                        }
                    }
                }
            }
        }
    }
}
