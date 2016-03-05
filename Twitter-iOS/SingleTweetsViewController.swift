//
//  SingleTweetsViewController.swift
//  Twitter-iOS
//
//  Created by Md Miah on 3/5/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

class SingleTweetsViewController: UIViewController, UITextViewDelegate {
     var replyTweet: Tweet?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
     let maxChars = 140
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
        tweetButton.backgroundColor = UIColor(red: 85/225.0, green: 172/225.0, blue: 238/225.0, alpha: 1.0)
        tweetButton.tintColor = UIColor.whiteColor()
        tweetButton.contentEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 10)
        tweetButton.layer.cornerRadius = 5
        tweetButton.clipsToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardIsShowing:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        if replyTweet != nil {
            placeholderLabel.hidden = true
            tweetTextView.text = "@\(replyTweet!.user!.screenname!): "
            charCountLabel.text = "\(maxChars - tweetTextView.text.characters.count)"
        }
        
        let currentUser = User.currentUser!
        let imageUrl = NSURL(string: currentUser.profileImageUrl!)
        profileImageView.setImageWithURL(imageUrl!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= maxChars
    }
    
    func textViewDidChange(textView: UITextView) {
        let charCount = textView.text.characters.count
        if charCount > 0 {
            placeholderLabel.hidden = true
            charCountLabel.text = "\(maxChars - charCount)"
        } else {
            placeholderLabel.hidden = false
            charCountLabel.text = "\(maxChars)"
        }
    }
    
    func keyboardIsShowing(notification: NSNotification) {
        var keyboardInfo = notification.userInfo!
        let keyboardFrame: CGRect = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 5
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = self.view.frame.minY
        })
    }
    
 
    @IBAction func onTweet(sender: AnyObject) {
        var params = [String: AnyObject]()
        params["status"] = tweetTextView.text
        if replyTweet != nil {
            params["in_reply_to_status_id"] = replyTweet!.idStr!
        }
        TwitterClient.sharedInstance.newTweetWithParams(params, completion: {(tweet, error) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("new_tweet", object: nil, userInfo: ["new_tweet": tweet!])
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        print("canceled")
        self.dismissViewControllerAnimated(true, completion: nil)
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
