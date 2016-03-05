//
//  DetailViewController.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/25/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var tweet: Tweet!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = NSURL(string: tweet.profileImageUrl!)
        profileImageView.setImageWithURL(imageURL!)
        userNameLabel.text = tweet.name
        userHandleLabel.text = "@\(tweet.userName!)"
        tweetLabel.text = tweet.text
        timestampLabel.text = tweet.timeAgo
        likesLabel.text = "\(tweet.favoritesCount!)"
        retweetsLabel.text = "\(tweet.retweetsCount!)"
        if tweet.favorited == true {
            likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
            likesLabel.text = String(tweet!.favoritesCount! + 1)
        } else {
            likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
        }
        if tweet.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
            retweetsLabel.text = String(tweet!.retweetsCount! + 1)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
        }
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if tweet.favorited == false {
            TwitterClient.sharedInstance.favoriteWithParams(tweet.idStr!, params: nil, completion: { (error) -> ()in
                self.likeButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Selected)
                self.likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
                self.tweet.favorited = true
                
                self.likesLabel.text = String(self.tweet!.favoritesCount! + 1)
            })
        } else {
            TwitterClient.sharedInstance.unfavoriteWithParams(tweet.idStr!, params: nil, completion: { (error) -> () in
                self.likeButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Selected)
                self.likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
                self.tweet.favorited = false
                
                self.likesLabel.text = String(self.tweet!.favoritesCount!)
            })
        }
    }

    @IBAction func retweet(sender: AnyObject) {
        if tweet.retweeted == false {
            TwitterClient.sharedInstance.retweetWithParams(tweet.idStr!, params: nil, completion: { (error) -> ()in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Selected)
                self.retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
                self.tweet.retweeted = true
                self.retweetsLabel.text = String(self.tweet!.retweetsCount! + 1)
            })
        } else {
            TwitterClient.sharedInstance.unretweetWithParams(tweet.idStr!, tweet: tweet, params: nil, completion: { (error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Selected)
                self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
                self.tweet.retweeted = false
                self.retweetsLabel.text = String(self.tweet!.retweetsCount!)
            })
        }
        
    }
    @IBAction func onRetweet(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("replied", object: nil, userInfo: ["repliedToTweet": tweet])
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
