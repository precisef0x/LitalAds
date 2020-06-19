import Foundation
import UIKit
import GameKit

public class LitalAds {
    public static let shared = LitalAds()
    
    private init() {
        
    }
    
    public func initialize() {
        IDHelper.shared.initAppID()
        
        GKLocalPlayer.local.authenticateHandler = {(viewController : UIViewController!, error : Error!) -> Void in
            if viewController != nil {
                if let currentVC = UIApplication.topViewController() {
                    pleaseDispatchMainAsync {
                        currentVC.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    public func showAd() {
        IDHelper.shared.getIDs { (appId, adsId, gcId, deviceName, iosVersion, model) in
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "lital.codee.studio"
            urlComponents.path = "/ads/get"
            urlComponents.queryItems = [
                URLQueryItem(name: "appId", value: appId ?? "none"),
                URLQueryItem(name: "adsId", value: adsId ?? "none"),
                URLQueryItem(name: "gcId", value: gcId ?? "none"),
                URLQueryItem(name: "deviceName", value: deviceName ?? "none"),
                URLQueryItem(name: "iosVersion", value: iosVersion ?? "none"),
                URLQueryItem(name: "model", value: model ?? "none")
            ]
            
            if let url = urlComponents.url {
                let storyboard = UIStoryboard(name: "LitalAds", bundle: Bundle(for: LitalAds.self))
                if let vc = storyboard.instantiateViewController(withIdentifier: "litalAdsVC") as? LitalAdViewController {
                    if LitalAPI().ads_auth(appId: appId ?? "null", adsId: adsId ?? "null", gcId: gcId ?? "null", deviceModel: model ?? "null", iosVersion: iosVersion ?? "null", deviceName: deviceName ?? "null") {
                        vc.authed = true
                        vc.url = url
                    } else {
                        vc.authed = false
                        vc.url = URL(string: "https://lital.codee.studio/ads/common")
                    }
                    
                    if let currentVC = UIApplication.topViewController() {
                        pleaseDispatchMainSync {
                            print("[i] presenting ad..")
                            currentVC.present(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
}
