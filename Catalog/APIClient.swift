//
//  APIClient.swift
//  Catalog
//
//  Created by Xiomara on 8/14/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit
import Alamofire

class APIClient {

    static let shared = APIClient()
    
    let baseURL = "https://api.coursera.org/api/catalogResults.v2"
    
    var baseParams = [
        "q":"search",
        "start":0,
        "limit":10,
        "fields":"courseId,onDemandSpecializationId,courses.v1(name,photoUrl,partnerIds),onDemandSpecializations.v1(name,logo,courseIds,partnerIds),partners.v1(name)",
        "includes":"courseId,onDemandSpecializationId,courses.v1(partnerIds)"
    ]
    
    
    func searchInCatalog(searchFor: String!, block: (Dictionary<String, AnyObject>?) -> Void) {
        baseParams.updateValue(searchFor, forKey: "query")
        
        Alamofire.request(
            .GET,
            baseURL,
            headers: nil,
            parameters: baseParams,
            encoding: .URL).validate().responseJSON { response in
            
            if response.result.isSuccess {
                if let dict = response.result.value as? Dictionary<String,AnyObject> {
                    block(dict)
                } else {
                    block(nil)
                }
            }
        }
    }
}