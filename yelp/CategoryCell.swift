//
//  CategoryCell.swift
//  yelp
//
//  Created by Nekkalapudi, Satish on 9/21/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!

    @IBOutlet weak var categoryView: UIView!
    var section: Int = -1
    var row: Int = -1

    var filterViewDelegate:FilterViewControllerDelegate?

    var dealCategory = ["Offering a Deal"]
    var distanceCategories = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var distanceCategoriesValue = [0, 482, 1609, 8046, 32186]
    var sortByCategories = ["Best Match": 0, "Distance": 1, "Rating": 2]
    var generalCategories = ["Delivery", "Bars", "Vegetarian", "Vegan", "Music Venues", "Fast Food", "Cafe"]
    var generalCategoriesValues = ["fooddeliveryservices", "bars", "vegetarian", "vegan", "musicvenues", "hotdogs", "cafes"]
    
    var customSwitch: SevenSwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        println("aawakefromnib \(row) and section \(section)")
        // Initialization code
        
        customSwitch = SevenSwitch()
        categoryView.addSubview(customSwitch)

        customSwitch.thumbImage = UIImage(named: "yelp-flower-icon.png")
        customSwitch.frame = CGRectMake(0, 0, 60, 25)
        
        customSwitch.offLabel.text = "OFF"
        customSwitch.onLabel.text = "ON"
        customSwitch.onLabel.textColor = UIColor.whiteColor()
        customSwitch.offLabel.textColor = UIColor.whiteColor()
        customSwitch.inactiveColor =  UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 225.0/255.0, alpha: 1)
        customSwitch.onTintColor =  UIColor(red:0.0, green:191.0/255.0, blue:1.0, alpha:1.0)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchControlValueChanged (sender: UISwitch) {
        println("switchControlValueChanged \(row) and section \(section)")
        var selected: Bool = sender.on
        if (section == 0) {
            filterViewDelegate?.dealsCategorySelected(selected)
        } else if section == 1 {
//            filterViewDelegate?.distanceCategorySelected(distanceCategoriesValue[row])
        } else if section == 2 {
  //          filterViewDelegate?.sortByCategorySelected([Int](sortByCategories.values)[row])
        } else if section == 3 {
            filterViewDelegate?.generalCategorySelected(generalCategoriesValues[row], selected: selected)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        println("layoutSubviews \(row) and section \(section)")
        self.categoryLabel.sizeToFit()
        if (section == 0) {
            self.categoryLabel.text = dealCategory[row]
        }
        if (section == 3) {
            self.categoryLabel.text = generalCategories[row]
        }

        customSwitch.addTarget(self, action: Selector("switchControlValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)

    }
    

}
