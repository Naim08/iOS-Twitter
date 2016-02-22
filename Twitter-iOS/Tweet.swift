//
//  Tweet.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var timePassed: Int = 0
    var timeSince: String!
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
            let now = NSDate()
            let then = timestamp
            timePassed = Int(now.timeIntervalSinceDate(then!))
            
            if timePassed >= 86400 {
                timeSince = String(timePassed / 86400)+"d"
            }
            if (3600..<86400).contains(timePassed) {
                timeSince = String(timePassed/3600)+"h"
            }
            if (60..<3600).contains(timePassed) {
                timeSince = String(timePassed/60)+"m"
            }
            if timePassed < 60 {
                timeSince = String(timePassed)+"s"
            }
        }
        
    }
    
    class func tweetswithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }


}
