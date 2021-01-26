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
    
    //Puzzle outlets
    @IBOutlet weak var puzzleView: UIView!
    @IBOutlet weak var puzzleQuestionLabel: UILabel!
    @IBOutlet weak var puzzleAnswerInput: UITextField!
    var puzzleAnswers: [Int] = []
    
    //RPS Outlets
    @IBOutlet weak var rpsView: UIView!
    @IBOutlet weak var rpsResult: UILabel!
    
    //Shake Outlets
    @IBOutlet weak var shakeView: UIView!
    
    //Other Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
        //Set the time and date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, Y"
        
        dateLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "hh:mm"
        timeLabel.text = dateFormatter.string(from: date)
        
        
        //Hide all inactive wakemethods
        puzzleView.isHidden = true
        rpsView.isHidden = true
        shakeView.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AlarmActivationViewController.playSound), userInfo: nil, repeats: true)
        setAlarmType()
        //print(MathExpression.random())
    }
    
    @objc func playSound()
    {
        AudioServicesPlayAlertSound(currentAlarm!.alarmTone)
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
            case "Factor":
                self.puzzleAnswers = factorAction(puzzleQuestionLabel: puzzleQuestionLabel)
                puzzleView.isHidden = false
            case "Smash":
                print("")
            case "RPS":
                rpsView.isHidden = false
                //Get Choice here
                //rpsAction(choice: choice)
            case "Shake":
                shakeView.isHidden = false
                shakeAction()
            default:
                print("Invalid alarm type")
            }
        }
    }
   
    //Verfies and ends factoring WVM
    @IBAction func checkBinomialSolution(_ sender: Any) {
        if let input = puzzleAnswerInput.text {
            if let numericalInput = Int(input) {
                if puzzleAnswers.contains(numericalInput) {
                    endAlarm()
                }
            }
        }
    }
    
    //Gets RPS choice
    @IBAction func rockChoice(_ sender: Any) {
        if rpsAction(choice: .rock)! {
            endAlarm()
        } else {
            rpsResult.text = "Paper: You lost, try again"
        }
    }
    
    @IBAction func paperChoice(_ sender: Any) {
        if rpsAction(choice: .paper)! {
            endAlarm()
        } else {
            rpsResult.text = "Scissors: You lost, try again"
        }
    }
    @IBAction func scissorChoice(_ sender: Any) {
        if rpsAction(choice: .scissors)! {
            endAlarm()
        } else {
            rpsResult.text = "Rock: You lost, try again"
        }
    }
    
    
    
    //Standard way to turn off and close the alarm
    func endAlarm() {
        timer?.invalidate()
        print("Alarm solved")
        dismiss(animated: true, completion: nil)
    }
}
