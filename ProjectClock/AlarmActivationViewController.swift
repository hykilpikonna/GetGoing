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
    var timer: Timer?
    var currentAlarm: Alarm?
    
    init?(coder: NSCoder, currentAlarm: Alarm)
    {
        self.currentAlarm = currentAlarm
        //print(currentAlarm.wakeMethod)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AlarmActivationViewController.playSound), userInfo: nil, repeats: true)
        setAlarmType()
        print(MathExpression.random())
    }
    
    @objc func playSound()
    {
        AudioServicesPlayAlertSound(SystemSoundID(1005))
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    func setAlarmType()
    {
        if let alarm = currentAlarm
        {
            switch alarm.wakeMethod.name {
            case "Walk":
                walkAction()
            case "Jump":
                jumpAction()
            case "Puzzle":
                puzzleAction()
            case "Smash":
                print("")
            default:
                print("Invalid alarm type")
            }
        }
    }
    
    @IBAction func debugForceStop(_ sender: Any)
    {
        timer?.invalidate()
    }
}
