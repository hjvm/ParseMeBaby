//
//  LoginViewController.swift
//  ParseMeBaby
//
//  Created by Héctor J. Vázquez on 6/20/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
        var signInButtonClicked = false
    @IBOutlet weak var signUpButton: UIButton!
        var signUpButtonClicked = false
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
 

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        
        if !signInButtonClicked{
            //Move button
            UIView.animateWithDuration(1, animations:{
                
                self.signInButton.frame = CGRectMake(self.signInButton.frame.origin.x, self.signInButton.frame.origin.y + 115, self.signInButton.frame.size.width, self.signInButton.frame.size.height)
                
                //Display text boxes
                self.usernameField.alpha = 1
                self.passwordField.alpha = 1
            
            //Display other buttons
            self.signUpButton.alpha = 0
            self.cancelButton.alpha = 1
            
            })
        }
        if signInButtonClicked {
            //Sign in old user
            PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!){ (user: PFUser?, error: NSError?) -> Void in
            
                if user != nil {
                    print("You are logged in.")
                    self.performSegueWithIdentifier("loginSegue", sender: nil)
                }else{
                    //Display pop-up
                    let alertController = UIAlertController(title: "Invalid username or password", message:
                        "The username and password you have entered do not match.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    

                }
            }
        }
        
        //Prepare for second click
        signInButtonClicked = true
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        
        if !signUpButtonClicked{
            UIView.animateWithDuration(1.0, animations:{
                self.signUpButton.frame = CGRectMake(self.signUpButton.frame.origin.x, self.signUpButton.frame.origin.y + 42, self.signUpButton.frame.size.width, self.signUpButton.frame.size.height)
            
                //Display text boxes
                    self.usernameField.alpha = 1
                    self.passwordField.alpha = 1
      
   
                //Display other buttons
                self.signInButton.alpha = 0
                self.cancelButton.alpha = 1
            })
        }
        if signUpButtonClicked{
            //Create new user
            let newUser = PFUser()
        
            //Assign attributes
            newUser.username = usernameField.text
            newUser.password = passwordField.text
        
            //Sign up
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
                if success{
                    print("User created")
                    self.performSegueWithIdentifier("loginSegue", sender: nil)

                }else{
                    print(error?.localizedDescription)
                    if error?.code == 202{
                        print("Username taken")
                    }
                    //Display pop-up
                    let alertController = UIAlertController(title: "Invalid username", message:
                        "The username you have requested is already in use", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        //Prepare for second click
        signUpButtonClicked = true
    }

    @IBAction func cancelLogIn(sender: AnyObject) {
        if signInButtonClicked{
            
            //Move button
            UIView.animateWithDuration(1, animations:{
                self.signInButton.frame = CGRectMake(self.signInButton.frame.origin.x, self.signInButton.frame.origin.y - 115, self.signInButton.frame.size.width, self.signInButton.frame.size.height)
            
                self.signInButtonClicked = false
                self.signUpButton.alpha = 1
                })
    

        }else if signUpButtonClicked{
            
            //Move button
            UIView.animateWithDuration(1, animations:{
                self.signUpButton.frame = CGRectMake(self.signUpButton.frame.origin.x, self.signUpButton.frame.origin.y - 42, self.signUpButton.frame.size.width, self.signUpButton.frame.size.height)
           
            self.signUpButtonClicked = false
            self.signInButton.alpha = 1
            })
            
        }
        //Hide Other Fields
        UIView.animateWithDuration(1.0, animations: {
            self.usernameField.alpha = 0
            self.passwordField.alpha = 0
            self.cancelButton.alpha = 0
        })
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
