//
//  DistanceAndSortCell.swift
//  yelp
//
//  Created by Nekkalapudi, Satish on 9/21/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class DistanceAndSortCell: UITableViewCell {


    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var downPointerImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var unSelectImageView: UIImageView!
    var section: Int = -1
    var row: Int = -1
    var sectionExpanded = false
    var isRowSelected = false
    
    var sortByRowSelected = 0
    var distanceRowSelected = 0

    var filterViewDelegate:FilterViewControllerDelegate?
    
    var distanceCategories = ["Auto", "0.5 miles", "1 mile", "2 miles", "5 miles"]
    var distanceCategoriesValue = [0, 482, 1609, 8046, 32186]
    var sortByCategories = ["Best Match", "Distance", "Rating"]
    var sortByCategoriesValue = [0,1,2]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        println("DistanceAndSortCell aawakefromnib \(row) and section \(section)")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.categoryLabel.sizeToFit()

        if (section == 1) {
            self.categoryLabel.text = distanceCategories[row]
            if (row == distanceRowSelected) {
                isRowSelected = true
            } else {
                isRowSelected = false
            }
        }
        if (section == 2) {
            self.categoryLabel.text = sortByCategories[row]
            if (row == sortByRowSelected) {
                isRowSelected = true
            } else {
                isRowSelected = false
            }
        }
        if (sectionExpanded) {
            downPointerImageView.hidden = true
            if (isRowSelected) {
                selectImageView.hidden = false
                unSelectImageView.hidden = true
            } else {
                selectImageView.hidden = true
                unSelectImageView.hidden = false
            }
        } else {
            selectImageView.hidden = true
            unSelectImageView.hidden = true
            downPointerImageView.hidden = false
        }
    }
    


}
