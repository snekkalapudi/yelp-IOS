//
//  ListingsViewController.swift
//  yelp
//
//  Created by Nekkalapudi, Satish on 9/21/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class ListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterViewControllerDelegate{

    @IBOutlet weak var listingsTableView: UITableView!

    var searchBar: UISearchBar!

    @IBOutlet var listingsTablePanGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    
    var filterViewController: FilterViewController!
    // Yelp API Client
    var client: YelpClient!

    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "tB9eqgSrQ83on0-ni70isg"
    let yelpConsumerSecret = "PweXP8Tme65LjYuM5Fsvn34Jygg"
    let yelpToken = "z4zBZ2ZDvty5suw9_C2Z6S2Z3--JLVLc"
    let yelpTokenSecret = "08UivbGmij5TwTo7psImU4DpWW8"
    
    var searchTerm = "Restaurants"
    var dealsFilter = false
    var radiusFilter = 0
    var categoryFilter: [String] = []
    var sortByFilter = 0
    var distanceFilterRowSelected = 0
    var sortByFilterRowSelected = 0
    var currentPage = 1
    
    
    var listings : [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        listingsTableView.delegate = self
        listingsTableView.dataSource = self
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 40.0))
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.currentPage = 1
        self.listings = []

        listingsTableView.rowHeight = UITableViewAutomaticDimension
        listingsTableView.estimatedRowHeight = 89.0;
  
        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController!.navigationBar.tintColor = UIColor(red: 196.0/255.0, green: 18.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 196.0/255.0, green: 18.0/255.0, blue: 0.0/255.0, alpha: 1.0)

        searchBar.tintColor = UIColor(red: 196.0/255.0, green: 18.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        searchBar.barTintColor = UIColor(red: 196.0/255.0, green: 18.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        searchBar.placeholder = "Restaurants"
        
        filterView.backgroundColor = UIColor(red: 196.0/255.0, green: 18.0/255.0, blue: 0.0/255.0, alpha: 1.0)

        filterButton.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        filterButton.layer.borderWidth = 1;
        filterButton.layer.cornerRadius = 5;

        filterButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        filterButton.layer.shadowColor = UIColor.whiteColor().CGColor
        filterButton.layer.shadowOpacity = 0.5

        filterButton.tintColor = UIColor.whiteColor()
        filterButton.backgroundColor = UIColor(red: 196.0/255.0, green: 18.0/255.0, blue: 0.0/255.0, alpha: 1.0)

        filterButton.addTarget(self, action: "filterButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)

        // Load data from yelp
        loadDataFromYelp()

    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
        searchBar.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromYelp() {
        // Make the API call to yelp to the get the closest listings
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.search(self.searchTerm, categories: self.categoryFilter, dealsFilter: self.dealsFilter, radiusFilter: self.radiusFilter, sortByFilter: self.sortByFilter, offset: 20*self.currentPage, limit: 20, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            self.listings += response["businesses"] as [NSDictionary]
            NSLog("Listings count \(self.listings.count)")
            
            // Do any additional setup after loading the view.
            self.listingsTableView.reloadData()
            self.view.endEditing(true);
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
   
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Change this to get from the listing
        NSLog("After reload data: listings count \(self.listings.count)")
        return listings.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Load a new view
        NSLog("selected \(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Hello I am at row \(indexPath.row) and section \(indexPath.section)")
        if ((currentPage*20) - indexPath.row == 5) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                self.currentPage += 1
                self.loadDataFromYelp()
            })
        }
        var listingCell = tableView.dequeueReusableCellWithIdentifier("ListingCell") as ListingCell
        listingCell.listing = listings[indexPath.row]
        return listingCell
    }

    func filterButtonClicked() {
        NSLog("Search clicked")
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        searchBar.endEditing(true)
        self.filterViewController = storyBoard.instantiateViewControllerWithIdentifier("FilterViewController") as FilterViewController
        filterViewController.delegate = self
        filterViewController.distanceRowSelected = self.distanceFilterRowSelected
        filterViewController.sortByRowSelected = self.sortByFilterRowSelected
        filterViewController.categoriesSelected = self.categoryFilter
        filterViewController.dealsCategorySelected = self.dealsFilter
        
        //TODO change this to modal controller as per the lecture
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }

    func dealsCategorySelected(selected: Bool) {
        NSLog("deals selected : \(selected)")
        self.dealsFilter = selected
        filterViewController.dealsCategorySelected = self.dealsFilter
    }
    
    func sortByCategorySelected(sortBy: Int, rowSelected: Int) {
        NSLog("Sort By: \(sortBy)")
        self.sortByFilter = sortBy
        self.sortByFilterRowSelected = rowSelected
    }
    
    func distanceCategorySelected(distanceInMeters: Int, rowSelected: Int) {
        NSLog("Distance in meters: \(distanceInMeters)")
        self.radiusFilter = distanceInMeters
        self.distanceFilterRowSelected = rowSelected
    }
    
    func generalCategorySelected(category: String, selected: Bool) {
        NSLog("Category selected : \(category) selected: \(selected)")

        if (selected) {
            self.categoryFilter.append(category)
            NSLog("Adding category \(category)")
        } else {
            var removeIndex = find(self.categoryFilter, category)
            if let index = removeIndex {
                NSLog("Removing category \(category)")
                self.categoryFilter.removeAtIndex(index)
            }
        }
        self.filterViewController.categoriesSelected = self.categoryFilter
    }
    
    func filterSearchClicked() {
        self.currentPage = 1
        self.listings = []
        self.loadDataFromYelp()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchTerm = searchBar.text
        self.currentPage = 1
        self.listings = []
        self.loadDataFromYelp()
        searchBar.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
