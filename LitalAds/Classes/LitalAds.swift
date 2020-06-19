import Foundation

public class LitalAds {
    public static let shared = LitalAds()
    
    private init() {
        
    }
    
    public func initialize() {
        IDHelper.shared.initAppID()
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
                    vc.url = url
                    if let currentVC = UIApplication.topViewController() {
                        pleaseDispatchMainSync {
                            currentVC.present(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
}
