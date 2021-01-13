//
//  NotificationLogic.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/13/21.
//

import Foundation
import CoreMotion
import UserNotifications

let motionManager = CMMotionManager()

func getAccelerometer() {
    motionManager.startAccelerometerUpdates()
    //print(motionManager.accelerometerData)
    if let accelerometerData = motionManager.accelerometerData {
        print("Acclerometer: \(accelerometerData)")
    }
}

func walkAction() {
    
}

func jumpAction() {
    
}

func puzzleAction() {
    
}

func smashAction() {
    
}
