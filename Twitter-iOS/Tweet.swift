//
//  Tweet.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit
import RelativeFormatter

class Tweet: NSObject {
    var text: String?
    var userName: String?
    var name: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeAgo: String?
    var user: User?
    var id: NSNumber?
    var idStr: String?
    var favoritesCount: Int?
    var retweetsCount: Int?
    var retweeted: Bool?
    var favorited: Bool?
    var replyedId: String?
    var retweeted_status: NSDictionary?
      var profileImageUrl: String?
    var dictionary: NSDictionary
  
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        user = User(dictionary:dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        userName = user!.screenname
        name = user!.name
        profileImageUrl = user!.profileImageUrl
        id = dictionary["id"] as? Int
        idStr = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        replyedId = dictionary["in_reply_to_status_id_str"] as? String
        retweeted_status = dictionary["retweeted_status"] as? NSDictionary
        favoritesCount = user!.favoritesCount
        retweetsCount = dictionary["retweet_count"] as? Int
        
        createdAtString = dictionary["created_at"] as? String
        let formater = NSDateFormatter()
        formater.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formater.dateFromString(createdAtString!)
        timeAgo = createdAt!.relativeFormatted()

    }
    
    class func tweetswithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
             tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    class func tweetAsDictionary(dict: NSDictionary) -> Tweet {
        var tweet = Tweet(dictionary: dict)
        return tweet
    }

}
