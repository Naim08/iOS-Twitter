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
    func newTweetWithParams(params: NSDictionary!, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("tweeted successfully")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("did not tweet")
                completion(tweet: nil, error: error)
        })
    }
    
    func retweetWithParams(id: String, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        print(id)
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully retweeted")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweeting")
                completion(error: error)
        })
    }
    
    func unretweetWithParams(id: String, tweet: Tweet?, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        
        var originalTweetId = ""
        var retweetId = ""
        if tweet!.retweeted == false {
            print("cannot untweet if have not retweeted")
        } else if tweet!.retweeted_status == nil{
            originalTweetId = tweet!.idStr!
        } else {
            originalTweetId = tweet!.retweeted_status!["id_str"] as! String
        }
        
        GET("1.1/statuses/show/\(originalTweetId).json?include_my_retweet=1", parameters: params, success: { (operation: NSURLSessionDataTask!,response: AnyObject?) -> Void in
            let fullTweet = response as! NSDictionary
            let retweet = fullTweet["current_user_retweet"]!
            retweetId = retweet["id_str"] as! String
            print("got full tweet")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting full tweet")
        })
        
        
        POST("1.1/statuses/unretweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully unretweeted")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error unretweeting")
                completion(error: error)
        })
    }
    
    
    func favoriteWithParams(id: String, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully favorited")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error favoriting")
                completion(error: error)
        })
    }
    
    func unfavoriteWithParams(id: String, params: NSDictionary?, completion:(error: NSError?) -> ()) {
        
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successfully unfavorited")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error unfavoriting")
                completion(error: error)
        })
    }
    func userTimelineWithParams(id: String, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!,response: AnyObject?) -> Void in
            let tweets = Tweet.tweetswithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("eror getting user timeline")
                completion(tweets: nil, error: error)
        })
    }

    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!,response: AnyObject?) -> Void in
            let tweets = Tweet.tweetswithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("eror getting home timeline")
                completion(tweets: nil, error: error)
        })
    }

}
