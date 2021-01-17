//
//  AlarmActivator.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/17/21.
//

import Foundation

/**
 Class to activate alarms when the user is inside the app
 
 Note: This will not run when app is switched to the background or when the display is turned off, but it will run right after the user switched back to the app.
 */
class AlarmActivator
{
    /// Interval in seconds
    static var interval = 1.0
    
    /// Timer for scheduled calls
    var timer: Timer?
    
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
        // Get the alarm to activate
        guard let alarm = Alarms.fromLocal().listActivating.first else { return }
        NSLog(JSON.stringify(alarm)!)
        
    }
}
