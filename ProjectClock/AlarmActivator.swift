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
        guard let alarm = Alarms.fromLocal().listActivating.first else { return }
        NSLog(JSON.stringify(alarm)!)
        performSegue(withIdentifier: "activate-alarmactivate-alarm", sender: nil)
    }
}
