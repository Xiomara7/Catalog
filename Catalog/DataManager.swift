//
//  DataManager.swift
//  Catalog
//
//  Created by Xiomara on 8/14/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
}

class CatalogItem {
    var name: String!
    var universityName: String!
    var partnerIds: Array<Int>!
}

class Specialization: CatalogItem {
    var numberOfCourses: Int!
}

class Catalog {
    var courses: [NSDictionary]!
    var specializations: [NSDictionary]!
    var coursesList: [NSDictionary]!
    var partnersIds: [String]!
    var universities = NSMutableDictionary()
    
    var next: String!
    
    func parseCatalog(catalog: Dictionary<String,AnyObject>) {
        let tempDict = catalog["linked"] as! Dictionary<String,AnyObject>
        
        courses = tempDict["courses.v1"] as? [NSDictionary]
        specializations = tempDict["onDemandSpecializations.v1"] as? [NSDictionary]
        coursesList = tempDict["partners.v1"] as? [NSDictionary]
        
        // universities: A table to store universities info by ID: 
        // { <"partnerID"> : <University Info> }
        if let partners = coursesList {
            for partner in partners {
                universities.setValue(partner, forKey: partner["id"] as! String)
            }
        }
        
        if let paging = catalog["paging"] as? Dictionary<String,AnyObject> {
            if let nextValue = paging["next"] as? String {
                next = nextValue
            }
        }
    }
}
