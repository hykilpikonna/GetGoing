//
//  NotificationLogic.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/13/21.
//

import Foundation
import CoreMotion

let motionManager = CMMotionManager()

func getAccelerometer() {
    motionManager.startAccelerometerUpdates()
    
    if let accelerometerData = motionManager.accelerometerData {
        print(accelerometerData)
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
