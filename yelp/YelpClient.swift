//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
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

    func search(term: String, categories: [String], dealsFilter: Bool, radiusFilter: Int, sortByFilter: Int, offset: Int, limit: Int, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        var categoriesString = getCommaSeperatedString(categories)
        NSLog(categoriesString)
        var parameters = ["term": term, "location": "San Jose", "category_filter" : categoriesString, "deals_filter": dealsFilter, "sort": sortByFilter, "offset": offset, "limit": limit] as NSMutableDictionary
        if (radiusFilter > 0) {
            parameters["radius_filter"] = radiusFilter
        }
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}
