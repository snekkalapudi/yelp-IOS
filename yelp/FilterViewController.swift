//
//  FilterViewController.swift
//  yelp
//
//  Created by Nekkalapudi, Satish on 9/21/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate
{
    func dealsCategorySelected(selected: Bool)
    func distanceCategorySelected(distanceInMeters: Int, rowSelected: Int)
    func sortByCategorySelected(sortBy: Int, rowSelected: Int)
    func generalCategorySelected(category: String, selected: Bool)
    func filterSearchClicked()
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate:FilterViewControllerDelegate?

    @IBOutlet weak var categoryTableView: UITableView!

    var sectionExpanded = [1: false, 2: false, 3: false]
    
    var distanceRowSelected = 0
    var sortByRowSelected = 0
    var dealsCategorySelected = false
    var categoriesSelected : [String] = []

    var distanceCategoriesValue = [0, 482, 1609, 8046, 32186]
    var sortByCategoriesValue = [0,1,2]
    var generalCategoriesValues = ["fooddeliveryservices", "bars", "vegetarian", "vegan", "musicvenues", "hotdogs", "cafes"]
    var categoryRowsSelected: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        // Do any additional setup after loading the view.

        categoryTableView.rowHeight = 40
        categoryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        categoryTableView.showsVerticalScrollIndicator = false
        
        self.navigationItem.title = "Filter"
        
        var searchButton = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Done, target: self, action: "searchClicked")
        searchButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = searchButton
        
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancelClicked")
        cancelButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = cancelButton
        
        // Calculate all the category rows selected so we can turn their switch on.
        for category in categoriesSelected {
            categoryRowsSelected.append(find(generalCategoriesValues, category)!)
        }

        self.categoryTableView.reloadData()
    }

    func searchClicked() {
        self.delegate?.filterSearchClicked()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func cancelClicked() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if (section == 0) {
            var headerView =  UIView(frame: CGRect(x:0, y:0, width: 320, height: 10))
            headerView.backgroundColor = UIColor.whiteColor()
            return headerView
        }

        var headerView = UIView(frame: CGRect(x:0, y:0, width: 320, height: 40))
        
        headerView.backgroundColor = UIColor.whiteColor()
        var headerLabel = UILabel(frame: CGRect(x:0, y:0, width:320, height: 40))

        if (section == 0) {
            headerLabel.text = "Deals"
        }
        if (section == 1) {
            headerLabel.text = "Distance"
        }
        if (section == 2) {
            headerLabel.text = "Sort By"
        }
        if (section == 3) {
            headerLabel.text = "Category"
        }
        headerLabel.font = UIFont(name: "helvetica neue", size: 14)

        
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 10.0
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        categoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var section = indexPath.section
        if (section == 1 || section == 2) {
            if (sectionExpanded[section] == true) {
                if (section == 1) {
                    distanceRowSelected = indexPath.row
                    self.delegate?.distanceCategorySelected(distanceCategoriesValue[indexPath.row], rowSelected: indexPath.row)
                } else {
                    sortByRowSelected = indexPath.row
                    self.delegate?.sortByCategorySelected(sortByCategoriesValue[indexPath.row], rowSelected: indexPath.row)
                }
                sectionExpanded[section] = false
            } else {
                sectionExpanded[section] = true
            }
        }
        
        if (section == 3 && indexPath.row == 3 && !sectionExpanded[section]!) {
            sectionExpanded[section] = true
            for category in categoriesSelected {
                categoryRowsSelected.append(find(generalCategoriesValues, category)!)
            }
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }

    
    func setInitialSwitchValue(cell: CategoryCell, section: Int, row: Int) -> CategoryCell {
        if (section == 0) {
            if (dealsCategorySelected) {
                cell.customSwitch.setOn(true, animated: false)
            }
        }
        if (section == 3) {
            var isCategoryRowSelected = find(categoryRowsSelected, row)
            if let isSelected = isCategoryRowSelected {
                cell.customSwitch.setOn(true, animated: false)
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var section = indexPath.section
        if (section == 3 && indexPath.row == 3 && !sectionExpanded[section]!) {
            var cell = tableView.dequeueReusableCellWithIdentifier("CategorySeeAllCell") as CategorySeeAllCell
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
            cell.contentView.layer.cornerRadius = 4.0
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        if (section == 0 || section == 3) {
            var cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as CategoryCell
            cell.section = indexPath.section
            cell.row = indexPath.row
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
            cell.contentView.layer.cornerRadius = 4.0
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.filterViewDelegate = delegate
            cell = setInitialSwitchValue(cell, section: indexPath.section, row: indexPath.row)
            return cell

        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("DistanceAndSortCell") as DistanceAndSortCell
            cell.section = indexPath.section
            if (!sectionExpanded[section]!) {
                if (section == 1) {
                    cell.row = distanceRowSelected
                } else if section == 2 {
                    cell.row = sortByRowSelected
                }
            } else {
                cell.row = indexPath.row
            }
            cell.sortByRowSelected = self.sortByRowSelected
            cell.distanceRowSelected = self.distanceRowSelected
            cell.sectionExpanded = sectionExpanded[section]!
            cell.contentView.layer.borderWidth = 0.5

            cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
            cell.contentView.layer.cornerRadius = 4.0

            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.filterViewDelegate = delegate
            return cell
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            if (sectionExpanded[section] == true) {
                return 5
            } else {
                return 1
            }
        }
        
        if (section == 2) {
            if (sectionExpanded[section] == true) {
                return 3
            } else {
                return 1
            }
        }
        if (section == 3) {
            if (sectionExpanded[section] == true) {
                return 7
            } else {
                return 4
            }
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
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
