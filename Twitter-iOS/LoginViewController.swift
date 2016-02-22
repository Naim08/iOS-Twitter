//
//  LoginViewController.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/21/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLoginAction(sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        client.login({ () -> () in
            //segue to the next view controller
            print("hey i logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        
        
        
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
