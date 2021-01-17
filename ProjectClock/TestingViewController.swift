//
//  TestingViewController.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/13/21.
//

import UIKit
import UserNotifications

class TestingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
              (granted, error) in
              if granted {
                  print("Authorized Notifications")
              } else {
                  print("Error: No notification access")
              }
          }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getAccel(_ sender: Any) {
        getAccelerometer()
    }
    
    //Sends a test notification
    @IBAction func sendNotification(_ sender: Any) {
        let alarm = Alarm(enabled: true, hour: 7, minute: 20, text: "Good morning!", wakeMethod: WVM(name: "walking", desc: "Walk"))
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
