//
//  TestingViewController.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/13/21.
//

import UIKit
import UserNotifications

class TestingViewController: UIViewController
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
        let alarm = Alarm(hour: 7, minute: 20, text: "Good morning!", wakeMethod: WVM(name: "walking", desc: "Walk"))
        
        let content = UNMutableNotificationContent()
        
        //Date formatting to string
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .long
        
        //Notification content
        content.title = alarm.text
        content.subtitle = formatter1.string(from: today)
        content.body = "Wake method: \(alarm.wakeMethod.name)"
        
        // Notification image content
        let imageName = "clock"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
        
        // Readies notification to be sent
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // Sends notification
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
