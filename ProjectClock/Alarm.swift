//
//  Alarm.swift
//  ProjectClock
//
//  Created by Aaron Saporito on 1/13/21.
//

import Foundation

class Alarm {
    var alarmTime: Date
    var text: String
    var wakeMethod: WVM
    
    init(alarmTime: Date, text: String, wakeMethod: WVM) {
        
        self.alarmTime = alarmTime
        self.text = text
        self.wakeMethod = wakeMethod
    }
}
    
