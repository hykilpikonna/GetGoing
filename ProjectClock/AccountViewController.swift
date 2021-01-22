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
            alert("Username Invalid", "Username must be 3 to 16 characters long, and must only contain a-z, 0-9, underscore, and minus signs (-).")
            return
        }
        guard let pass = password.text, pass.count > 8 else
        {
            alert("Password Invalid", "Password must be more than 8 characters long")
            return
        }
        
        // Send register request
        alert("Registering...", "Please Wait", okayable: true)
        send(APIs.register, ["username": name, "password": pass]) { it in
            print(it)
        }
    }
    
    @IBAction func login(_ sender: Any)
    {
        
    }
}

class ManageVC: UIViewController
{
    
}
