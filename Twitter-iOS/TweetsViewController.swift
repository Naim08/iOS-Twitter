//
//  TweetsViewController.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    var tweets: [Tweet]!
    var filteredTweets: [Tweet]?
    var tweet: Tweet?
    var isLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var refreshControl: UIRefreshControl!
    var favoriteStates = [Int:Bool]()
    var retweetStates = [Int:Bool]()
    let favoritePressedImage = UIImage(named: "like-action-on.png")! as UIImage
    let retweetPressedImage = UIImage(named: "retweet-action-on.png")! as UIImage

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //navigation stuff
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "twitter-icon")
        imageView.image = image
        self.navigationItem.titleView = imageView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileTap:", name: "profileTapNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTimeline:", name: "new_tweet", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onReply:", name: "replied", object: nil)
        
        //Set up infinite Scroll
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        //Set up refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "didRefresh", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        

        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets:[Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
       
        
       
        

        // Do any additional setup after loading the view.
    }

    @IBAction func profileSegue(sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: User.currentUser!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onReply(notification: NSNotification) {
        performSegueWithIdentifier("composeSegue", sender: notification.userInfo!["repliedToTweet"])
    }
  
    func onProfileTap(notification: NSNotification) {
        performSegueWithIdentifier("profileSegue", sender: notification.userInfo!["user"])
    }
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    func updateTimeline(notification: NSNotification) {
        let newTweet = notification.userInfo!["new_tweet"] as! Tweet
        tweets!.insert(newTweet, atIndex: 0)
        tableView.reloadData()
    }
    func didRefresh() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if error != nil {
                print("error refreshing")
            }else {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        })
        refreshControl.endRefreshing()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "profileSegue" {
            let user = sender as! User
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = user
        } else if segue.identifier == "singleTweetSegue" {

        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.tweet = tweet
        print("segue passed")
        } else if segue.identifier == "composeSegue" {
            if let tweet = sender as? Tweet {
                let singleTweetsViewController = segue.destinationViewController as! SingleTweetsViewController
                singleTweetsViewController.replyTweet = tweet
            }
        }

    }
    

}
// TableView methods
extension TweetsViewController: UITableViewDelegate, UITableViewDataSource  {
public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tweets != nil {
        return (tweets?.count)!
    } else {
        return 0
    }    }
public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    self.tweet = tweets![indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
    
    cell.tweet = tweets?[indexPath.row]
    
    // Infinite Scroll Attempt
    if indexPath.row == self.tweets!.count - 3 && isLoading == false {
        isLoading = true
        
        //Progress Indicater
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
        
        let params = ["max_id": self.tweet!.idStr!] as NSDictionary
        TwitterClient.sharedInstance.homeTimelineWithParams(params, completion: { (tweets, error) -> () in
            
            if error != nil {
                print("error loading more tweets")
            } else {
                self.tweets = self.tweets! + tweets!
            }
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            self.isLoading = false
            
        })
    }
    return cell
}
}
