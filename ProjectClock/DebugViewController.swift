//
//  TestingViewController.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/13/21.
//

import UIKit
import UserNotifications

class DebugViewController: UIViewController
{
    @IBOutlet weak var userModeButton: UIButton!
    var darkMode = false
    
    @IBOutlet weak var wvmInput: UITextField!
    @IBOutlet weak var wvmStepper: UIStepper!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //Sends a test notification
    @IBAction func sendNotification(_ sender: Any)
    {
        Notification.scheduleNotification(alarm: Alarms.fromLocal().listEnabled[0])
    }
    
    @IBAction func addAlarm(_ sender: Any)
    {
        let (h, m, _) = Date().getHMS()
        let alarm = Alarm(hour: h, minute: m, text: "Test alarm - \(h * m)", wakeMethod: wvms[Int(wvmStepper.value)], repeats: [true, true, true, true, true, true, true], lastActivate: Date().added(.minute, -1))
        
        Alarms.fromLocal().apply { $0.list.append(alarm) }.localSave()
        Notification.scheduleNotification(alarm: alarm)
    }
    
    @IBAction func deleteAlarm(_ sender: Any)
    {
        Alarms.fromLocal().apply { $0.list.removeAll() }.localSave()
    }
    
    @IBAction func wvmStepperChange(_ sender: Any)
    {
        wvmInput.text = String(Int(wvmStepper.value))
    }
    
    @IBAction func switchViewingMode(_ sender: Any) {
        if !darkMode {
            view.window?.overrideUserInterfaceStyle = .dark
            userModeButton.setTitle("Switch to Light Mode", for: .normal)
            darkMode = true
        } else {
            view.window?.overrideUserInterfaceStyle = .light
            userModeButton.setTitle("Switch to Dark Mode", for: .normal)
            darkMode = false
        }
    }
}
