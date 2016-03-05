//
//  UserTweetCell.swift
//  Twitter-iOS
//
//  Created by Md Miah on 3/5/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

class UserTweetCell: UITableViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var tweetID: String?
    var tweet: Tweet! {
        didSet {
            timestampLabel.text = tweet.timeAgo
            tweetLabel.text = tweet.text
            userLabel.text = "@\(tweet.userName!)"
            userNameLabel.text = tweet.name
            likesLabel.text = "\(tweet.favoritesCount!)"
            retweetsLabel.text = "\(tweet.retweetsCount!)"
            retweetsLabel.text! == "0" ? (retweetsLabel.hidden = true) : (retweetsLabel.hidden = false)
            likesLabel.text! == "0" ? (likesLabel.hidden = true) : (likesLabel.hidden = false)
            let imageURL = NSURL(string: tweet.profileImageUrl!)
            profileImageView.setImageWithURL(imageURL!)
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
            tweetID = tweet.idStr!
        }
    }

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet.retweeted == false {
            TwitterClient.sharedInstance.retweetWithParams(self.tweetID!, params: nil, completion: { (error) -> ()in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Selected)
                self.retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
                self.tweet.retweeted = true
                
                if self.retweetsLabel.text! > "0" {
                    self.retweetsLabel.text = String(self.tweet!.retweetsCount! + 1)
                } else {
                    self.retweetsLabel.hidden = false
                    self.retweetsLabel.text = String(self.tweet!.retweetsCount! + 1)
                }
            })
        } else {
            TwitterClient.sharedInstance.unretweetWithParams(self.tweetID!, tweet: tweet, params: nil, completion: { (error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Selected)
                self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
                self.tweet.retweeted = false
                
                if self.retweetsLabel.text! > "0" {
                    self.retweetsLabel.text = String(self.tweet!.retweetsCount!)
                } else {
                    self.retweetsLabel.hidden = false
                    self.retweetsLabel.text = String(self.tweet!.retweetsCount!)
                }
                
                
            })
        }
    }
    
    @IBAction func onLike(sender: AnyObject) {
        if tweet.favorited == false {
            TwitterClient.sharedInstance.favoriteWithParams(self.tweetID!, params: nil, completion: { (error) -> ()in
                self.likeButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Selected)
                self.likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
                self.tweet.favorited = true
                
                if self.likesLabel.text! > "0" {
                    self.likesLabel.text = String(self.tweet!.favoritesCount! + 1)
                } else {
                    self.likesLabel.hidden = false
                    self.likesLabel.text = String(self.tweet!.favoritesCount! + 1)
                }
            })
        } else {
            TwitterClient.sharedInstance.unfavoriteWithParams(self.tweetID!, params: nil, completion: { (error) -> () in
                self.likeButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Selected)
                self.likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
                self.tweet.favorited = false
                
                if self.likesLabel.text! > "0" {
                    self.likesLabel.text = String(self.tweet!.favoritesCount!)
                } else {
                    self.likesLabel.hidden = false
                    self.likesLabel.text = String(self.tweet!.favoritesCount!)
                }
                
            })
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("replied", object: nil, userInfo: ["repliedToTweet": tweet])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
