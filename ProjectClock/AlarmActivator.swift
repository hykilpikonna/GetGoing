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
    var alarm: Alarm?
    
    /// Timer for getting family alarm updates
    var familyTimer: Timer?
    
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
        familyTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(AlarmActivator.checkFamily), userInfo: nil, repeats: true)
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
        //NSLog("Check")
        
        // Get the alarm to activate
        let alarms = Alarms.fromLocal()
        guard let alarm = alarms.listActivating.first else { return }
        
        // Update alarm info
        alarm.apply {
            $0.lastActivate = Date()
            if $0.oneTime { $0.enabled = false }
        }
        
        alarms.localSave()
        self.alarm = alarm
        // Segue
        //NSLog(JSON.stringify(alarm)!)
        performSegue(withIdentifier: "activate-alarm", sender: alarm)
    }
    
    @IBSegueAction func sendAlarm(_ coder: NSCoder) -> AlarmActivationViewController?
    {
        return AlarmActivationViewController(coder: coder, currentAlarm: alarm!)
    }
    
    /**
     Check family alarm updates
     */
    @objc func checkFamily()
    {
        guard localStorage.string(forKey: "family") != nil else { return }
        
        send(APIs.familyAlarmUpdates)
        {
            guard $0 != "" else { return }
            
            var changed = false
            let alarms = Alarms.fromLocal()
            $0.csv.forEach
            {
                guard let alarm = JSON.parse(Alarm.self, $0) else { return }
                if (!alarms.list.contains { $0.timeText == alarm.timeText })
                {
                    alarms.list.append(alarm)
                    changed = true
                }
            }
            alarms.localSave()
            
            guard changed else { return }
            self.msg("New alarm!", "A family member added an alarm for you!")
            {
                AlarmViewController.staticTable?.reloadData()
            }
        }
    }
}
