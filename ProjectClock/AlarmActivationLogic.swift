//
//  NotificationLogic.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/13/21.
//

import Foundation
import CoreMotion
import UserNotifications
import UIKit

var motionManager = CMMotionManager()
var regulate = true

func walkAction() {
    
}

func jumpAction() {
    
}

func shakeAction() {
    regulate = true
    
    
    
    motionManager.accelerometerUpdateInterval = 0.2
    motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { data, error in
        if data!.acceleration.x > 5 {
            print("DO SOMETHING SPECIAL")
            regulate = false
        }
    }
}

func rpsAction(choice: RPS.Choice) -> Bool? {
    let rps = RPS()
    return rps.playRPS(you: choice, computer: RPS.randomComputerChoice())
}

// Handles the core logic behind the factoring alarm
func factorAction(puzzleQuestionLabel: UILabel) -> [Int] {
    let problem = QuadraticProb()
    
    let answer = problem.getAnswer()
    let problemString = problem.getProblem()
    
    puzzleQuestionLabel.text = "Solve: \(problemString)"
    print("Answer: \(answer)")
    return answer
}

func smashAction() {
    
}
