//
//  AlarmActivationViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/17/21.
//

import UIKit
import AVFoundation

/**
 View controlling alarm activation and dismissal
 */
class AlarmActivationViewController: UIViewController
{
    var timer: Timer?
    var currentAlarm: Alarm?
    
    // Puzzle outlets
    @IBOutlet weak var puzzleView: UIView!
    @IBOutlet weak var puzzleQuestionLabel: UILabel!
    @IBOutlet weak var puzzleAnswerInput: UITextField!
    var puzzleAnswers: [Int] = []
    
    // RPS Outlets
    @IBOutlet weak var rpsView: UIView!
    @IBOutlet weak var rpsResult: UILabel!
    
    // Shake Outlets
    @IBOutlet weak var shakeView: UIView!
    
    // Other Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    /**
     Constructor to receive alarm data from segue
     */
    init?(coder: NSCoder, currentAlarm: Alarm)
    {
        self.currentAlarm = currentAlarm
        //print(currentAlarm.wakeMethod)
        super.init(coder: coder)
    }
    
    /**
     Unused init
     */
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /**
     Called when the alarm activates
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the time and date
        dateLabel.text = Date().str("MMM d, Y")
        timeLabel.text = currentAlarm?.timeText
        
        // Hide all inactive wakemethods
        puzzleView.isHidden = true
        rpsView.isHidden = true
        shakeView.isHidden = true
        
        // Play sound
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AlarmActivationViewController.playSound), userInfo: nil, repeats: true)
        
        // Run alarm
        runAlarm()
    }
    
    /**
     Play alarm sound
     */
    @objc func playSound()
    {
        AudioServicesPlayAlertSound(currentAlarm!.alarmTone)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    /**
     Run alarm dismissal logic
     */
    func runAlarm()
    {
        if let alarm = currentAlarm
        {
            switch alarm.wakeMethod.name
            {
            case "Factor":
                self.puzzleAnswers = factorAction(puzzleQuestionLabel: puzzleQuestionLabel)
                puzzleView.isHidden = false
            case "RPS":
                rpsView.isHidden = false
            case "Shake":
                shakeView.isHidden = false
                shakeAction()
                if regulate {
                    endAlarm()
                }
            default:
                print("Invalid alarm type")
            }
        }
    }
   
    /**
     Verfies and ends factoring WVM
     */
    @IBAction func checkBinomialSolution(_ sender: Any) {
        if let input = puzzleAnswerInput.text {
            if let numericalInput = Int(input) {
                if puzzleAnswers.contains(numericalInput) {
                    endAlarm()
                }
            }
        }
    }
    
    /**
     Gets RPS choice
     */
    @IBAction func rpsChoice(_ sender: UIButton)
    {
        let rps = RPS()
        if rps.playRPS(you: [.rock, .paper, .scissors][sender.tag], computer: RPS.choices.randomElement()!)
        {
            endAlarm()
        }
        else
        {
            rpsResult.text = "\(["Paper", "Scissors", "Rock"][sender.tag]): You lost, try again"
        }
    }
    
    /**
     Standard way to turn off and close the alarm
     */
    func endAlarm()
    {
        timer?.invalidate()
        print("Alarm solved")
        dismiss(animated: true, completion: nil)
    }
}
