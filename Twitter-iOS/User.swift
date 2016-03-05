//
//  User.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit
var userDidLogoutNotification = "userDidLogoutNotification"
class User: NSObject {
    let id: Int?
    var idStr: String?
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary?
    var imageURL: NSURL?
    var location: String?
    var statusesCount: Int?
    var friendsCount: Int?
    var createdAt: NSDate?
    var favoritesCount: Int?
    var headerImageUrl: String?
    var headerBackgroundColor: String?
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    
    init(dictionary: NSDictionary)
    {
        self.dictionary = dictionary
        id = dictionary["id"] as? Int
        idStr = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        favoritesCount = dictionary["favourites_count"] as? Int
        headerImageUrl = dictionary["profile_banner_url"] as? String
        headerBackgroundColor = dictionary["profile_background_color"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        
        
        if profileImageUrl != nil {
            imageURL = NSURL(string: profileImageUrl!)!
        } else {
            imageURL = nil
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
            
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            
            }
        
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
            let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
            defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }

}
