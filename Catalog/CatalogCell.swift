//
//  CatalogCell.swift
//  Catalog
//
//  Created by Xiomara on 8/14/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit

class CatalogCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityNameLabel: UILabel!
    @IBOutlet weak var numberOfCoursesLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    func populateCell(item: NSDictionary) -> Void {
        self.nameLabel.text = item["name"] as? String
        
        if let coursesList = item["courseIds"] as? NSArray {
            self.numberOfCoursesLabel.text = "\(coursesList.count) courses"
        }
        if let photoURL = item["photoUrl"] as? String {
            self.itemImageView.sd_setImageWithURL(NSURL(string: photoURL))
        }
        if let logoURL = item["logo"] as? String {
            self.itemImageView.sd_setImageWithURL(NSURL(string: logoURL))
        }
    }

}
