//
//  AlarmActivationViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/17/21.
//

import UIKit
import AVFoundation
import CoreMotion

var motion = CMMotionManager()

/**
 View controlling alarm activation and dismissal
 */
class AlarmActivationViewController: UIViewController
{
    var timer: Timer?
    var currentAlarm: Alarm
    
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
        timeLabel.text = currentAlarm.timeText
        
        // Hide all inactive wakemethods
        puzzleView.hide()
        rpsView.hide()
        shakeView.hide()
        
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
        AudioServicesPlayAlertSound(currentAlarm.alarmTone)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    /**
     Run alarm dismissal logic
     */
    func runAlarm()
    {
        // Check if the device has accelerometer
        var wvm = currentAlarm.wakeMethod.name
        if wvm == "Shake" && !motion.isDeviceMotionAvailable
        {
            msg("Error", "Accelerometer is not available on your device, so shaking your phone wouldn't work.")
            wvm = "Factor"
        }
        
        // Initialize alarm
        switch wvm
        {
        case "Factor":
            initFactorProblem()
            puzzleView.show()
        case "RPS":
            rpsView.show()
        case "Shake":
            shakeView.show()
            
            // Start motion detection
            let q = OperationQueue()
            motion.deviceMotionUpdateInterval = 0.2
            motion.startDeviceMotionUpdates(to: q) { data, error in
                if let a = data?.userAcceleration, sqrt(pow(a.x, 2) + pow(a.y, 2) + pow(a.z, 2)) > 4
                {
                    ui { self.endAlarm() }
                    motion.stopDeviceMotionUpdates()
                    q.cancelAllOperations()
                }
            }
        default:
            print("Invalid alarm type")
        }
    }
    
    func initFactorProblem()
    {
        let problem = QuadraticProb()
        puzzleAnswers = problem.getAnswer()
        
        puzzleQuestionLabel.text = "Solve: \(problem.getProblem())"
        print("Answer: \(puzzleAnswers)")
    }
   
    /**
     Verfies and ends factoring WVM
     */
    @IBAction func checkBinomialSolution(_ sender: Any)
    {
        if let input = puzzleAnswerInput.text,
           let numericalInput = Int(input),
           puzzleAnswers.contains(numericalInput)
        {
            endAlarm()
        }
    }
    
    /**
     Gets RPS choice
     */
    @IBAction func rpsChoice(_ sender: UIButton)
    {
        if RPS.playRPS(you: [.rock, .paper, .scissors][sender.tag], computer: RPS.choices.randomElement()!)
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
