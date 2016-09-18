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
    
    func searchInCatalog(searchFor: String!, start: String!, limit: String!, block: (Dictionary<String, AnyObject>?) -> Void) {
        var baseParams = [
            "q":"search",
            "includes":"courseId,onDemandSpecializationId,courses.v1(partnerIds)",
            "fields":"courseId,onDemandSpecializationId,courses.v1(name,photoUrl,partnerIds),onDemandSpecializations.v1(name,logo,courseIds,partnerIds),partners.v1(name)"
        ]
        
        baseParams.updateValue(searchFor, forKey: "query")
        baseParams.updateValue(start as! String, forKey: "start")
        baseParams.updateValue(limit, forKey: "limit")
        
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