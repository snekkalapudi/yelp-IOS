//
//  ListingCell.swift
//  yelp
//
//  Created by Nekkalapudi, Satish on 9/21/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class ListingCell: UITableViewCell {

    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingNameLabel: UILabel!
    @IBOutlet weak var listingDistanceLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var listingRatingsCountLabel: UILabel!
    @IBOutlet weak var listingAddressLabel: UILabel!
    @IBOutlet weak var listingCategoriesLabel: UILabel!

    var listing: NSDictionary = NSDictionary()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getCommaSeperatedString(arr: [String]) -> String {
        var str : String = ""
        for (idx, item) in enumerate(arr) {
            str += "\(item)"
            if idx < arr.count-1 {
                str += ","
            }
        }
        return str
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        listingNameLabel.text = listing["name"] as? String
        //listingNameLabel.text = "This is a ridiculously long name, lets see what it does"
        var imageUrl = listing["image_url"] as? String
        listingImageView.layer.cornerRadius = 5;
        listingImageView.clipsToBounds = true;
        if let listingImageUrl = imageUrl {
            listingImageView.setImageWithURL(NSURL(string: listingImageUrl))
        }

        var ratingsImageUrl = listing["rating_img_url"] as? String
        ratingsImageView.setImageWithURL(NSURL(string: ratingsImageUrl!))
        var numberOfRatings = listing["review_count"] as? Int
        listingRatingsCountLabel.text = "\(numberOfRatings!) Reviews"
        
        var location = listing["location"] as NSDictionary
        var displayAddress = location["display_address"] as [String]
        var labelDisplayAddress = ""
        if (displayAddress.count >= 2) {
            labelDisplayAddress = "\(displayAddress[0]), \(displayAddress[1])"
        }

        listingAddressLabel.text = labelDisplayAddress
        
        var categories = listing["categories"] as [[String]]
        var categoryLabelString = ""
        // TODO fix that trailing comma
        var count = 0
        for category in categories {
            count++
            if (count < categories.count) {
                categoryLabelString += "\(category[0]), "
            } else {
                categoryLabelString += "\(category[0])"
            }
        }
        listingCategoriesLabel.text = categoryLabelString
        
        // Get the real distance
       // listingDistanceLabel.text = "0.8mi"

    }
}
