//
//  SearchViewController.swift
//  Catalog
//
//  Created by Xiomara on 8/14/16.
//  Copyright © 2016 Xiomara. All rights reserved.
//

import UIKit
import PureLayout
import SDWebImage

class SearchViewController: UIViewController,
                            UICollectionViewDelegate,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UISearchBarDelegate {

    let searchBar = UISearchBar(frame: CGRect.zero)
    
    var showCourses = true
    var loadMore = false
    
    var searchResults = Catalog()
    var segmentedControl = UISegmentedControl(items: ["Courses","Specializations"])
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search catalog"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        segmentedControl.autoSetDimension(.Width, toSize: self.view.frame.size.width)
        segmentedControl.tintColor = UIColor.lightGrayColor()
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.hidden = true
        
        segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlChanged),
            forControlEvents: UIControlEvents.ValueChanged
        )
        
        collectionView.addSubview(segmentedControl)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - SearchBar Delegate Methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != nil {
            
            // Initial call to load search results
            APIClient.shared.searchInCatalog(
                searchBar.text,
                start: "0",
                limit: "20",
                block: { results in
                    self.searchResults.parseCatalog(results!)
                    self.collectionView.reloadData()
                }
            )
        }
    }
    
    func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            showCourses = true
        } else {
            showCourses = false
        }
        self.collectionView.reloadData()
    }
    
    // MARK - CollectionView Delegate & DataSource Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showCourses {
            if searchResults.courses != nil {
                return searchResults.courses.count
            }
        } else {
            if searchResults.specializations != nil {
                return searchResults.specializations.count
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("catalogCell", forIndexPath: indexPath) as! CatalogCell
        
        segmentedControl.hidden = false
        if showCourses {
            cell.numberOfCoursesLabel.hidden = true
            cell.populateCell(searchResults.courses[indexPath.row])
            
            if let partnersIds = searchResults.courses[indexPath.row]["partnerIds"] as? [String] {
                for id in partnersIds {
                    let university = searchResults.universities.valueForKey(id) as? Dictionary<String,String>
                    cell.universityNameLabel.text = university!["name"]
                }
            }
        } else {
            cell.numberOfCoursesLabel.hidden = false
            cell.populateCell(searchResults.specializations[indexPath.row])
            
            if let partnersIds = searchResults.specializations[indexPath.row]["partnerIds"] as? [String] {
                for id in partnersIds {
                    let university = searchResults.universities.valueForKey(id) as? Dictionary<String,String>
                    cell.universityNameLabel.text = university!["name"]
                }
            }
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if searchBar.text != nil {
            let next = searchResults.next
                
            APIClient.shared.searchInCatalog(
                searchBar.text,
                start: next,
                limit: "20",
                block: { results in
                    self.searchResults.parseCatalog(results!)
                    self.collectionView.reloadData()
                }
            )
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let sizeScreen = UIScreen.mainScreen().bounds
        return CGSizeMake(sizeScreen.width - 20.0, sizeScreen.height / 6)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.collectionView.endEditing(true)
    }
    
}
