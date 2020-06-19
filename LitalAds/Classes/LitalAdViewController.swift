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
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.closeButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.url != nil {
            let request = URLRequest(url: self.url!)
            self.webView.loadRequest(request)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pleaseDispatchMainAsyncAfter(self.delay) {
            self.closeButton.isHidden = false
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
