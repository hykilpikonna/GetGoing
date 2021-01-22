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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

class LoginVC: UIViewController
{
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func register(_ sender: Any)
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
        let a = alert("Registering...", "Please Wait")
        send(APIs.register, ["username": name, "password": pass.sha256]) { it in
            print(it)
            a.dismiss()
        }
        err: { e in
            a.dismiss { self.msg("An error occurred", "Maybe the server is on fire, just wait a few hours.") }
        }
    }
    
    @IBAction func login(_ sender: Any)
    {
        
    }
}

class ManageVC: UIViewController
{
    
}
