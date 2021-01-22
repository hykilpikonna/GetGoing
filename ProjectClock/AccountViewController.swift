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
        
    }
    
    @IBAction func login(_ sender: Any)
    {
        
    }
}

class ManageVC: UIViewController
{
    
}
