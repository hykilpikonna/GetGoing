//
//  ViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/6/21.
//

import UIKit

/**
 Account view controller controlling the two separate view controllers
 */
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
        
        // Error messages
        let errors = ["409 - [\"A0111\"]": "Account already exists, please login instead.",
                      "401 -": "Incorrect username/password",
                      "404 -": "Username does not exist in the database",
                      "406 - [\"A0101\"]": "Username invalid."
        ]
        
        // Send register request
        sendReq(login ? APIs.login : APIs.register,
                title: login ? "Logging in..." : "Registering...", errors: errors,
                params: ["username": name, "password": pass.sha256])
        {
            // Store username and password
            localStorage["name"] = name
            localStorage["pass"] = pass.sha256
            localStorage["id"] = $0
            
            // Send feedback
            if login { self.msg("Login success!", "Now you can use account features, yay!") }
            else { self.msg("Registration success!", "Now you have an account, yay!") }
            
            // Hide registration and show account detail view
            AccountViewController.this.login()
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

/**
 Account manage view controller
 */
class ManageVC: UIViewController
{
    static var this: ManageVC!
    
    @IBOutlet weak var lUsername: UILabel!
    @IBOutlet weak var lJoinDate: UILabel!
    
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
        lUsername.text = localStorage.string(forKey: "name")
        // TODO: Correct join date
        lJoinDate.text = localStorage.string(forKey: "id")
    }
    
    /**
     Called when the user clicks the logout button
     */
    @IBAction func logout(_ sender: Any)
    {
        AccountViewController.this.logout()
    }
    
    /**
     Called when the user clicks the delete account button
     */
    @IBAction func deleteAccount(_ sender: Any)
    {
        sendReq(APIs.delete, title: "Deleting...")
        {
            print("Deleted! \($0)")
            self.msg("Deleted!", "You are erased from our database, you no longer exist.")
            self.logout(sender)
        }
    }
}
