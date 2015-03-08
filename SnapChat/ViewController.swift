//
//  ViewController.swift
//  SnapChat
//
//  Created by Ronald Hernandez on 3/7/15.
//  Copyright (c) 2015 Ronald Hernandez. All rights reserved.
//

import UIKit
import ParseUI

class ViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()


    @IBAction func signInWithFbButtonTapped(sender: AnyObject) {
        var permissions = ["public_profile", "email"]


        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in

            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")

                    self.performSegueWithIdentifier("showUsers", sender: self)
                } else {
                    println("User logged in through Facebook!")
                    self.performSegueWithIdentifier("showUsers", sender: self)
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

            }

    //if you try to segueway in view did load and go straight to the user page. Instead do it in the view did apprear. 

    override func viewDidAppear(animated: Bool) {

        //test if there is a user. if there is perform the segue. 

        if PFUser.currentUser() != nil{
            self.performSegueWithIdentifier("showUsers", sender: self)
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

