//
//  AlarmActivator.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/17/21.
//

import Foundation
import UIKit

/**
 Class to activate alarms when the user is inside the app
 
 Note: This will not run when app is switched to the background or when the display is turned off, but it will run right after the user switched back to the app.
 */
class AlarmActivator: UITabBarController
{
    /// Interval in seconds
    static var interval = 2.0
    
    /// Timer for scheduled calls
    var timer: Timer?
    
    override func viewDidLoad()
    {
        start()
    }
    
    /**
     Start detecting alarms
     */
    func start()
    {
        if timer != nil { return }
        timer = Timer.scheduledTimer(timeInterval: AlarmActivator.interval, target: self, selector: #selector(AlarmActivator.check), userInfo: nil, repeats: true)
    }
    
    /**
     Stop detecting alarms
     */
    func stop()
    {
        timer?.invalidate()
        timer = nil
    }
    
    /**
     Check alarm
     */
    @objc func check()
    {
        NSLog("Check")
        
        // Get the alarm to activate
        let alarms = Alarms.fromLocal()
        guard let alarm = alarms.listActivating.first else { return }
        
        // Update alarm info
        alarm.lastActivate = Date()
        if alarm.oneTime { alarm.enabled = false }
        alarms.localSave()
        
        // Segue
        NSLog(JSON.stringify(alarm)!)
        performSegue(withIdentifier: "activate-alarm", sender: alarm)
    }
}
