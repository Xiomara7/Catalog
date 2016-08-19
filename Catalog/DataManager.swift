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
    var courses: NSArray!
    var specializations: NSArray!
    
    func parseCatalog(catalog: Dictionary<String,AnyObject>) {
        let tempDict = catalog["linked"] as! Dictionary<String,AnyObject>
        
        courses = tempDict["courses.v1"] as! NSArray
        specializations = tempDict["onDemandSpecializations.v1"] as! NSArray
        
        print("courses: \(courses)")
        print("specializations: \(specializations)")
    }
}

struct Pagination {
    var next: Int!
    var total: Int!
}

