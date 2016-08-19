//
//  SearchViewController.swift
//  Catalog
//
//  Created by Xiomara on 8/14/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,
                            UICollectionViewDelegate,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UISearchBarDelegate {

    let searchBar = UISearchBar(frame: CGRect.zero)
    var searchResults = Catalog()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search catalog"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - SearchBar Delegate Methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != nil {
            APIClient.shared.searchInCatalog(searchBar.text) { results in
                self.searchResults.parseCatalog(results!)
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK - CollectionView Delegate & DataSource Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchResults.courses != nil {
            return searchResults.courses.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("catalogCell", forIndexPath: indexPath) as! CatalogCell
        
        cell.nameLabel.text = searchResults.courses[indexPath.row]["name"] as? String
        //cell.universityNameLabel.text = "University of Puerto Rico, Rio Piedras"
        //cell.numberOfCoursesLabel.text = "10-course Specialization"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let sizeScreen = UIScreen.mainScreen().bounds
        return CGSizeMake(sizeScreen.width - 20.0, sizeScreen.height / 6)
    }
    
}
