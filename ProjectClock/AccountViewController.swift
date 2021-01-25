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
        ["id", "user", "pass", "family"].forEach { localStorage.removeObject(forKey: $0) }
        
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
            
            send(APIs.familyGet)
            {
                $0.localSave()
                self.loginSuccess(login)
            }
            err: { it in print(it); self.loginSuccess(login) }
        }
    }
    
    private func loginSuccess(_ login: Bool)
    {
        ui
        {
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
    
    @IBOutlet weak var lCurrentFamily: UILabel!
    
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
        // TODO: Implement join date (not important)
        lJoinDate.text = localStorage.string(forKey: "id")
        
        // Display family name
        if let family = Family.fromLocal()
        {
            lCurrentFamily.text = family.name
        }
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

/**
 Family view controller that displays family info or create/join family buttons
 */
class FamilyVC: UIViewController
{
    // No family view - prompt to create/join a family
    @IBOutlet weak var noFamilyView: UIView!
    var createMode: Bool!
    
    @IBAction func btnCreate(_ sender: Any)
    {
        createMode = true
        performSegue(withIdentifier: "family-create-join", sender: nil)
    }
    
    @IBAction func btnJoin(_ sender: Any)
    {
        createMode = false
        performSegue(withIdentifier: "family-create-join", sender: nil)
    }
    
    @IBSegueAction func segueCreateJoin(_ coder: NSCoder) -> FamilyCreateJoinVC?
    {
        return FamilyCreateJoinVC(coder: coder, create: createMode)
    }
    
    // Family view - Display family information and controls
    @IBOutlet weak var familyView: UIView!
    
    override func viewDidLoad()
    {
        if let _ = Family.fromLocal()
        {
            noFamilyView.isHidden = true
            familyView.isHidden = false
        }
        else
        {
            noFamilyView.isHidden = false
            familyView.isHidden = true
        }
    }
    
    /**
     Called when the user clicks the change pin button
     */
    @IBAction func btnChangePin(_ sender: Any)
    {
        self.enterPin("Change Pin", "Enter your OLD pin:") { oldPin in
            
            self.enterPin("Change Pin", "Enter your NEW pin:") { newPin in
                
                guard newPin.count >= 4 else { self.msg("Pin Too Weak", "Your family pin must be 4 numbers or more."); return }
                
                self.sendReq(APIs.familyChangePin, title: "Updating Pin...", params: ["oldPin": oldPin, "newPin": newPin]) { it in
                    
                    self.msg("Update Success!", "Your family pin is updated.")
                }
            }
        }
    }
    
    /**
     Called when the user clicks the leave or delete family button
     */
    @IBAction func btnLeave(_ sender: UIButton)
    {
        let i = sender.tag
        let action = ["Leave", "Delete"][i]
        let title = ["Leaving...", "Deleting..."][i]
        let msg = ["You left the family.", "You deleted the family."][i]
        
        enterPin()
        {
            self.sendReq(APIs.familyAction, title: title, params: ["pin": $0, "action": action]) { it in
                
                // Leave or delete, clear local storage's family section
                if i == 0 || i == 1 { localStorage.removeObject(forKey: "family") }
                
                self.msg("\(action) Success!", msg)
            }
        }
    }
}

/**
 Create or join a family
 */
class FamilyCreateJoinVC: UIViewController
{
    let createMode: Bool
    @IBOutlet weak var lFamilyNameOrId: UILabel!
    @IBOutlet weak var bCreateJoin: UIButton!
    @IBOutlet weak var tNameOrId: UITextField!
    @IBOutlet weak var tPin: UITextField!
    
    /**
     Pass in create mode from FamilyVC
     */
    init?(coder: NSCoder, create: Bool)
    {
        createMode = create
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /**
     On load
     */
    override func viewDidLoad()
    {
        // Set UI according to createMode
        lFamilyNameOrId.text = createMode ? "Family Name" : "Family ID"
        bCreateJoin.setTitle(createMode ? "Create" : "Join", for: .normal)
        
        // Default name
        if createMode
        {
            tNameOrId.text = "\(localStorage.string(forKey: "name")!)'s Family"
        }
    }
    
    /**
     Called when the user clicks create or join button
     */
    @IBAction func btnCreateOrJoin(_ sender: Any)
    {
        // Check pin
        guard let pin = tPin.text, pin.count >= 4 else { msg("Pin Too Weak", "Your family pin must be 4 numbers or more."); return }
        
        if createMode
        {
            guard let name = tNameOrId.text, !name.isEmpty else { msg("Name Empty", "You must enter a family name"); return }
            
            // Create family
            sendReq(APIs.familyCreate, title: "Creating...", params: ["name": name, "pin": pin])
            {
                // Save
                $0.localSave()
                
                // Send success message
                self.msg("Created!", "Your family ID is \($0.fid)")
                {
                    self.dismiss()
                }
            }
        }
    }
}

