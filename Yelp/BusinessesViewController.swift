
//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var searchBar : UISearchBar = UISearchBar()

    var businesses: [Business]!
    var filteredData : [Business]!

    var term = "place"
    var isMoreDataLoading = false
    var offset : Int? = 20


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = businesses

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
        
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        //Set the searchBar onto the NavBar
        navigationItem.titleView = searchBar
        print("Reach Search")

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("Searching")
        filteredData = searchText.isEmpty ? businesses : businesses?.filter ({ (business : Business) -> Bool in
            //reference to business name from business.swift in Models folder
            return (business.name)!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        print("Reloading TableView")
        tableView.reloadData()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData != nil {
            return filteredData!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredData[indexPath.row]
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*func loadMoreData() {
        //Don't have configure session,just call it from the Business View
        //Added parameters to the class function to include the offset within the tableView
        Business.searchWithTerm("\(term)", sort: .Distance, categories: [], deals: true, offset: self.offset, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if (businesses != []) {
                //This conditional states that if the businesses does not equal to the array,
                //correct it by appending the other businesses
                for business in businesses {
                    print("Appending")
                    self.businesses.append(business)
                }
                //Update Flag
                self.isMoreDataLoading = false
                //Stop Loading Indicator
                self.loadingMoreView!.stopAnimating()
                
                //Reload and extend the offset to introduce the new data
                self.filteredData = self.businesses
                self.tableView.reloadData()
                self.offset! += 10
            }
            self.isMoreDataLoading = false
        })
    }*/
    


}
