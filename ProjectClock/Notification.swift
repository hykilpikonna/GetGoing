//
//  Notification.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/24/21.
//

import Foundation
import UserNotifications

class Notification {
    
    init(alarm: Alarm) {
        self.alarm = alarm
    }
    
    var alarm: Alarm
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        
        //Date formatting to string
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM d, h:mm"
        
        //Notification content
        content.title = alarm.text
        content.subtitle = formatter1.string(from: today)
        content.body = "Wake method: \(alarm.wakeMethod.name)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notif.caf"))
        
        // Notification image content
        let imageName = "clock"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
        
        // Scheduels alarm notification for proper time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alarm.nextActivate!.timeIntervalSince(Date()), repeats: false)
        let request = UNNotificationRequest(identifier: alarm.notificationID, content: content, trigger: trigger)
        
        // Sends notification
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
