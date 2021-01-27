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
