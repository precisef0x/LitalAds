//
//  LitalBaseAPI.swift
//  lital
//
//  Created by Onee Chan on 10/04/2020.
//  Copyright © 2020 codee. All rights reserved.
//

import Foundation

public class LitalBaseAPIResponse {
    var success: Bool = false
    var response: Dictionary<String, AnyObject>? = nil
    var error: String = ""
    
    var description : String {
        return "LitalBaseAPIResponse -> success=\(success); error=\(error); response=\(String(describing: response))"
    }
    
    init() {
        
    }
    
    init(response: Data?) {
        if response != nil {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: response!) as! Dictionary<String, AnyObject>
                if jsonData["success"] as! Bool == true {
                    self.success = true
                    self.response = jsonData["response"] as? Dictionary<String, AnyObject>
                } else {
                    self.success = false
                    self.error = jsonData["error"] as! String
                }
            } catch {
                self.success = false
                self.error = "fatal"
                print("LitalBaseAPIResponse.init error occured: \(error)")
            }
        } else {
            self.success = false
        }
    }
    
    func getField(name: String) -> Any?
    {
        if self.success == false {
            return nil
        }
        if let value = self.response?[name] {
            return value
        }
        return nil
    }
}

public class LitalBaseAPI {
    var base_url = ""
    var api_domain = ""
    
    init(domain: String) {
        api_domain = domain
        base_url = String.init(format: "%@%@%@", "https://", api_domain, "/api/")
    }
    
    func method_url(methodName: String) -> String
    {
        return self.base_url + methodName
    }
    
    @discardableResult func makeRequest(method: String, params: Dictionary<AnyHashable, Any>?) -> LitalBaseAPIResponse {
        let parameters = params ?? [:]
        let url = URL(string: self.method_url(methodName: method))!
        
        let methodType = method.components(separatedBy: ".").last!
        
        var theData: Data? = nil
        
        if methodType == "upload" {
            let (data, _, _) = URLSession.shared.synchronousPostDataTask(with: url, params: parameters)
            theData = data
        } else {
            let (data, _, _) = URLSession.shared.synchronousGetDataTask(with: url, params: parameters)
            theData = data
        }
        
        return LitalBaseAPIResponse(response: theData)
    }
}

extension URLSession {
    func synchronousPostDataTask(with url: URL, params: Dictionary<AnyHashable, Any>) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) {
            request.httpBody = httpBody
        }
        
        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
    
    func synchronousGetDataTask(with url: URL, params: Dictionary<AnyHashable, Any>?) -> (Data?, URLResponse?, Error?) {
        var requestURL = url
        if params != nil {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let queryItems = params!.map{
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }
            urlComponents?.queryItems = queryItems
            requestURL = (urlComponents?.url)!
        }
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: requestURL) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
