//
//  UserTableViewController.swift
//  SnapChat
//
//  Created by Ronald Hernandez on 3/8/15.
//  Copyright (c) 2015 Ronald Hernandez. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    var userArray: [String] = []
    var activeReceipient = 0

    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFUser.query()
        query.whereKey("username", notEqualTo: PFUser.currentUser().username)
        query.orderByDescending("username")

        var users = query.findObjects()




        for user in users {
            userArray.append(user.username)

            tableView.reloadData()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkForMessage"), userInfo: nil, repeats: true)

    }
    func checkForMessage(){

        var query = PFQuery(className: "Image")
        query.whereKey("receiverUsername", equalTo: PFUser.currentUser().username)

        var images = query.findObjects()

        var done = false


        for image in images {
            if done == false {


                
                var imageView:PFImageView  =  PFImageView()
                imageView.file = image["photo"] as! PFFile

                imageView.loadInBackground({ (photo, error) -> Void in

                    if error == nil {

                        var senderUsername = image["sender"]

                        var alert = UIAlertController(title: "You got a new picture!", message: "Message from \(senderUsername)", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in


                        var backgroundview = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                        backgroundview.backgroundColor = UIColor.blackColor()
                        backgroundview.alpha = 0.6
                        backgroundview.tag = 3

                    var displayImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                        self.view.addSubview(displayImage)
                        displayImage.tag = 3

          self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("hideMessage"), userInfo: nil, repeats: true)

                    }))

                        self.presentViewController(alert, animated: true, completion: nil)
                    }


                })





                done = true
            }

        }

    }
    func hideMessage(){

        for subview in self.view.subviews {
            if subview.tag == 3 {
                subview.removeFromSuperview()
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return userArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        cell.textLabel?.text = userArray[indexPath.row]

        return cell
    }


    func  imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)

        var imageToSend = PFObject(className:"Image")
        imageToSend["image"] = PFFile(name: "image.jpeg", data: UIImageJPEGRepresentation(image, 0.5)) 
        imageToSend["sender"] = PFUser.currentUser().username
        imageToSend["receiverUsername"] = userArray[activeReceipient]
        imageToSend.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                // The object has been saved.
                self.displayAlert("Image has been sent", error: "")

            } else {
                // There was a problem, check error.description
            }
        }


    }
    @IBAction func chooseImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activeReceipient = indexPath.row
         chooseImage(self)
    }

    func displayAlert(title:String, error:String) {

        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in

            self.dismissViewControllerAnimated(true, completion: nil)

        }))

        self.presentViewController(alert, animated: true, completion: nil)

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lougout"{

            PFUser.logOut()
    }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
