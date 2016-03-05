//
//  TweetCell.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit
import RelativeFormatter
import AFNetworking

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var likeLabel: UILabel!
 
    @IBOutlet weak var retweetlabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    let profileTap = UITapGestureRecognizer()
    var tweetID: String?
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            usernameLabel.text = "@\((tweet.user?.screenname)!)"
            tweetLabel.text = tweet.text
            timeLabel.text = tweet.timeAgo
            profileImage.setImageWithURL((tweet.user?.imageURL)!)
            likeLabel.text = "\(tweet.favoritesCount!)"
            retweetlabel.text = "\(tweet.retweetsCount!)"
            retweetlabel.text! == "0" ? (retweetlabel.hidden = true) : (retweetlabel.hidden = false)
            likeLabel.text! == "0" ? (likeLabel.hidden = true) : (likeLabel.hidden = false)
            if tweet.favorited == true {
                favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
                
            } else {
                favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
            }
            if tweet.retweeted == true {
                retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
                
            } else {
                retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
            }
            tweetID = tweet.idStr!
          
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        profileTap.addTarget(self, action: Selector("onProfileImageTap:"))
        profileImage.addGestureRecognizer(profileTap)
        profileImage.userInteractionEnabled = true
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName("replied", object: nil, userInfo: ["repliedToTweet": tweet])
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet.retweeted == false {
            TwitterClient.sharedInstance.retweetWithParams(self.tweetID!, params: nil, completion: { (error) -> ()in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Selected)
                self.retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
                self.tweet.retweeted = true
                
                if self.retweetlabel.text! > "0" {
                    self.retweetlabel.text = String(self.tweet!.retweetsCount! + 1)
                } else {
                    self.retweetlabel.hidden = false
                    self.retweetlabel.text = String(self.tweet!.retweetsCount! + 1)
                }
            })
        } else {
            TwitterClient.sharedInstance.unretweetWithParams(self.tweetID!, tweet: tweet, params: nil, completion: { (error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Selected)
                self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
                self.tweet.retweeted = false
                
                if self.retweetlabel.text! > "0" {
                    self.retweetlabel.text = String(self.tweet!.retweetsCount!)
                } else {
                    self.retweetlabel.hidden = false
                    self.retweetlabel.text = String(self.tweet!.retweetsCount!)
                }
                
                
            })
        }

    }
   
    @IBAction func onLike(sender: AnyObject) {
        if tweet.favorited == false {
            TwitterClient.sharedInstance.favoriteWithParams(self.tweetID!, params: nil, completion: { (error) -> ()in
                self.favoriteButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Selected)
                self.favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
                self.tweet.favorited = true
                
                if self.likeLabel.text! > "0" {
                    self.likeLabel.text = String(self.tweet!.favoritesCount! + 1)
                } else {
                    self.likeLabel.hidden = false
                    self.likeLabel.text = String(self.tweet!.favoritesCount! + 1)
                }
            })
        } else {
            TwitterClient.sharedInstance.unfavoriteWithParams(self.tweetID!, params: nil, completion: { (error) -> () in
                self.favoriteButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Selected)
                self.favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
                self.tweet.favorited = false
                
                if self.likeLabel.text! > "0" {
                    self.likeLabel.text = String(self.tweet!.favoritesCount!)
                } else {
                    self.likeLabel.hidden = false
                    self.likeLabel.text = String(self.tweet!.favoritesCount!)
                }
                
            })
        }
    }
    func onProfileImageTap(recognizer: UITapGestureRecognizer) {
        print(tweet.user!)
        NSNotificationCenter.defaultCenter().postNotificationName("profileTapNotification", object: nil, userInfo: ["user" : tweet.user!])
    }
}
