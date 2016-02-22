//
//  TwitterClient.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
let api = "https://api.twitter.com"
let consumerKey = "XUKst9fg5F3wJ8SSK1XhAKnYe"
let consumerSecret = "mIZVZ4aC9X1f5gt5cb6zWE9e3xsCJNfnVXX4fflneuOGdIfTcx"

class TwitterClient: BDBOAuth1SessionManager {

    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: api), consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login (success: () -> (), failure: (NSError) -> ())  {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://auth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Token Recieved")
            let url = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)"
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            
            
            }) { (error: NSError!) -> Void in
                print("Error trying to connect:\(error.localizedDescription)")
                self.loginFailure?(error)
        }
        
    }
    
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //print("Got access token.")
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            self.loginSuccess?()
            
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }

        
    }
    func logOut() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogout", object: nil)
    }
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetswithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("Account:\(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error:\(error.localizedDescription)")
                failure(error)
        })
        
    }

}
