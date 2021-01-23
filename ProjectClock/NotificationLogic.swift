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

func walkAction() {
    
}

func jumpAction() {
    
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

