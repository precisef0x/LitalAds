//
//  LitalAdViewController.swift
//  LitalAds
//
//  Created by Onee Chan on 17/06/2020.
//

import Foundation

class LitalAdViewController: UIViewController {
    let delay: Double = 20.0 // seconds
    var url: URL? = nil
    
    var authed: Bool = false
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var noAuthButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.closeButton.isHidden = true
        self.errorLabel.isHidden = true
        self.authButton.isHidden = true
        self.noAuthButton.isHidden = true
        
        if !self.authed {
            self.errorLabel.isHidden = false
            self.authButton.isHidden = false
            self.noAuthButton.isHidden = false
            
            self.webView.isHidden = true
        }
        
        if self.url != nil {
            let request = URLRequest(url: self.url!)
            self.webView.loadRequest(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pleaseDispatchMainAsyncAfter(self.delay) {
            self.closeButton.isHidden = false
        }
    }
    
    @IBAction func authButtonPressed(_ sender: Any) {
        if let idData = KeyChain.load(key: "litalAppID") {
            if let appId = String(data: idData, encoding: .utf8) {
                let urlString = "lital://app/bind/\(appId)"
                if let url = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("[i] Cannot open app..")
                    }
                }
            }
        }
        
        self.errorLabel.isHidden = true
        self.authButton.isHidden = true
        self.noAuthButton.isHidden = true
        self.webView.isHidden = false
    }
    
    @IBAction func noAuthButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        self.authButton.isHidden = true
        self.noAuthButton.isHidden = true
        self.webView.isHidden = false
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
