//
//  AlarmActivationViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/17/21.
//

import UIKit
import AVFoundation

class AlarmActivationViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AudioServicesPlayAlertSound(SystemSoundID(1005))
    }
}
