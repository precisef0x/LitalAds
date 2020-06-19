//
//  LitalAPI.swift
//  lital
//
//  Created by Onee Chan on 10/04/2020.
//  Copyright © 2020 codee. All rights reserved.
//

import Foundation
import UIKit

public class LitalAPIResponse: LitalBaseAPIResponse {
    var litalError: LitalError = .none
    
    init(_ apiResponse: LitalBaseAPIResponse) {
        super.init()
        
        self.success = apiResponse.success
        self.response = apiResponse.response
        self.error = apiResponse.error
        
        switch self.error {
        case "auth_error":
            self.litalError = LitalError.auth
        case "user_exists":
            self.litalError = LitalError.user_exists
        case "fatal":
            self.litalError = LitalError.fatal
        default:
            self.litalError = LitalError.unknown
        }
    }
}

enum LitalError {
    case auth
    case user_exists
    case unknown
    case fatal
    case none
}

public class LitalAPI: LitalBaseAPI {
    init() {
        super.init(domain: "lital.codee.studio")
    }
    
    @discardableResult override func makeRequest(method: String, params: Dictionary<AnyHashable, Any>?) -> LitalAPIResponse {
        return LitalAPIResponse(super.makeRequest(method: method, params: params))
    }
    
    func ads_auth(appId: String, adsId: String, gcId: String, deviceModel: String, iosVersion: String, deviceName: String) -> Bool {
        let response = self.makeRequest(method: "ads.auth", params: [
            "gc_id": gcId,
            "app_id": appId,
            "ads_id": adsId,
            "device_model": deviceModel,
            "ios_version": iosVersion,
            "device_name": deviceName
        ])

        return response.success
    }
}
