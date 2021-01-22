//
//  ViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/6/21.
//

import UIKit

class AccountViewController: UIViewController
{
    @IBOutlet var vLogin: UIView!
    @IBOutlet var vManage: UIView!
    
    // For instance references
    static var this: AccountViewController!
    
    /**
     Called when the user switch to this tab
     */
    override func viewDidLoad()
    {
        // Static instance reference
        AccountViewController.this = self
    
        // Check if already registered/logged in
        if localStorage.string(forKey: "id") != nil { login() }
        
        super.viewDidLoad()
    }
    
    /**
     Login from the account page
     */
    func login()
    {
        vLogin.isHidden = true
        vManage.isHidden = false
        ManageVC.this.display()
    }
    
    /**
     Logout
     */
    func logout()
    {
        // Remove login info
        ["id", "user", "pass"].forEach { localStorage.removeObject(forKey: $0) }
        
        // Switch UI
        vLogin.isHidden = false
        vManage.isHidden = true
    }
}

/**
 View controller for registration and login
 */
class LoginVC: UIViewController
{
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    /**
     Send user login/registration request
     
     - Parameter login: True: Login, False: Register
     */
    func userRequest(login: Bool)
    {
        // Verify username and password
        guard let name = username.text, name ~= "[A-Za-z0-9_-]{3,16}" else
        {
            msg("Username Invalid", "Username must be 3 to 16 characters long, and must only contain a-z, 0-9, underscore, and minus signs (-).")
            return
        }
        guard let pass = password.text, pass.count >= 8 else
        {
            msg("Password Invalid", "Password must be more than or equal to 8 characters long")
            return
        }
        
        // Send register request
        let a = alert(login ? "Logging in..." : "Registering...", "Please Wait")
        send(login ? APIs.login : APIs.register, ["username": name, "password": pass.sha256])
        {
            // Store username and password
            localStorage["name"] = name
            localStorage["pass"] = pass.sha256
            localStorage["id"] = $0
            
            a.dismiss
            {
                // Send feedback
                if login { self.msg("Login success!", "Now you can use account features, yay!") }
                else { self.msg("Registration success!", "Now you have an account, yay!") }
                
                // Hide registration and show account detail view
                ui { AccountViewController.this.login() }
            }
        }
        err:
        {
            print($0)
            a.dismiss { self.msg("An error occurred", "Maybe the server is on fire, just wait a few hours.") }
        }
    }
    
    /**
     Called when the user clicks register
     */
    @IBAction func register(_ sender: Any)
    {
        userRequest(login: false)
    }
    
    /**
     Called when the user clicks login
     */
    @IBAction func login(_ sender: Any)
    {
        userRequest(login: true)
    }
}

class ManageVC: UIViewController
{
    static var this: ManageVC!
    
    
    /**
     Called when the user switched to the account tab (whether the view container is hidden or not)
     */
    override func viewDidLoad()
    {
        // Static reference
        ManageVC.this = self
        super.viewDidLoad()
    }
    
    /**
     Display account info
     */
    func display()
    {
        
    }
    
    /**
     Called when the user clicks the logout button
     */
    @IBAction func logout(_ sender: Any)
    {
        
    }
}
