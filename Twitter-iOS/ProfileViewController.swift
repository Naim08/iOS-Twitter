//
//  ProfileViewController.swift
//  Twitter-iOS
//
//  Created by Md Miah on 3/5/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0
let offset_B_LabelHeader:CGFloat = 95.0
let distance_W_LabelHeader:CGFloat = 35.0

class ProfileViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    var user: User!
    var tweets: [Tweet]!
    @IBOutlet weak var headerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollContentView.backgroundColor = UIColor.clearColor()
        headerView.backgroundColor = UIColor.clearColor()
        
        let id = user!.idStr
        
        //Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        TwitterClient.sharedInstance.userTimelineWithParams(id!, params: nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        //User Info
        let imageURL = NSURL(string: user!.profileImageUrl!)
        profileImageView.setImageWithURL(imageURL!)
        print(user!.headerImageUrl)
        nameLabel.text = user!.name
        screenNameLabel.text = "@\(user!.screenname!)"
        followersLabel.text = "\(user!.followersCount!)"
        followingLabel.text = "\(user!.followingCount!)"
        tweetsLabel.text = "\(user!.tweetsCount!)"
        if user!.headerImageUrl != nil {
            headerImageView.setImageWithURL(NSURL(string: user!.headerImageUrl!)!)
        } else {
            let headerColor = UIColorFromRGB("0xFF\(user!.headerBackgroundColor!)")
            headerImageView.backgroundColor = headerColor
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        let scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
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
// TableView methods
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTweetCell", forIndexPath: indexPath) as! UserTweetCell
        
        cell.tweet = tweets![indexPath.row]
        cell.selectionStyle = .None
        
        return cell
    }

    
}