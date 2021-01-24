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
        Notification(alarm: Alarms.fromLocal().listEnabled[0]).sendNotification()
    }
    
    @IBAction func addAlarm(_ sender: Any)
    {
        let (h, m, _) = Date().getHMS()
        Alarms.fromLocal().apply { $0.list.append(Alarm(hour: h, minute: m, text: "Test alarm - \(h * m)", wakeMethod: wvms[1], repeats: [true, true, true, true, true, true, true], lastActivate: Date().added(.minute, -1))) }.localSave()
    }
    
    @IBAction func deleteAlarm(_ sender: Any)
    {
        Alarms.fromLocal().apply { $0.list.removeAll() }.localSave()
    }
}
