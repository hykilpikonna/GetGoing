//
//  Models.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/12/21.
//

import Foundation
import AVFoundation

struct Family: Codable
{
    var fid: Int
    var name: String
    var members: String
    // And a hidden field: admin pin
    
    var membersList: [String] { members.components(separatedBy: ",") }
    
    /// Save family to local storage
    func localSave()
    {
        localStorage.setValue(JSON.stringify(self)!, forKey: "family")
    }
    
    /// Read family object from local storage
    static func fromLocal() -> Family?
    {
        guard let f = localStorage.string(forKey: "family") else { return nil }
        return JSON.parse(Family.self, f)
    }
}

struct WVM: Codable
{
    let name: String
    let desc: String
}

let wvms = [
    WVM(name: "Factor", desc: "Factor a binomial"),
    WVM(name: "RPS", desc: "Win a game of rock paper scissors"),
    //WVM(name: "Smash", desc: "It'll never turn off"),
    //WVM(name: "Walk", desc: "Walk a few steps"),
    //WVM(name: "Jump", desc: "Make a few jumps")
]

class Alarm: Codable, Equatable
{
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.text == rhs.text &&
            lhs.alarmTone == rhs.alarmTone && lhs.notificationID == rhs.notificationID &&
            lhs.repeats == rhs.repeats
    }
    
    var enabled: Bool
    var hour: Int // Hour (24)
    var minute: Int
    var text: String
    var wakeMethod: WVM
    var alarmTone: SystemSoundID
    var notificationID: String
    
    /// What days does it repeat (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
    var repeats: [Bool]
    
    /// When is the last time that the alarm went off
    var lastActivate: Date
    
    /// Constructor
    init(enabled: Bool = true,
         hour: Int, minute: Int, text: String, wakeMethod: WVM,
         repeats: [Bool] = [false, true, true, true, true, true, false],
         lastActivate: Date = Date(),
         alarmTone: SystemSoundID = SystemSoundID(1005)
    )
    {
        self.enabled = enabled
        self.hour = hour
        self.minute = minute
        self.text = text
        self.wakeMethod = wakeMethod
        self.repeats = repeats
        self.lastActivate = lastActivate
        self.alarmTone = alarmTone
        self.notificationID = "notification.id.\(Int.random(in: 1...Int.max))"
    }
    
    /// Does it automatically disable after activating once
    var oneTime: Bool { repeats.allSatisfy { !$0 } }
    
    /// When should the alarm activate next since lastActivate?
    var nextActivate: Date?
    {
        let (y, m, d) = lastActivate.getYMD()
        let (nh, nm, _) = lastActivate.getHMS()
        
        // Create activation date
        var date = Date.create(y, m, d, hour, minute)
        
        // If it will activate tomorrow
        if nh > hour || (nh == hour && nm >= minute) { date = date.added(.day, 1) }
        
        // If it's one-time, don't have to check for repeating date
        if oneTime { return date }
        
        // Make sure it's repeating
        guard (repeats.contains { $0 }) else { return nil }
        
        // If the day is not one of the "repeat" days, keep adding 1 until it is
        while !repeats[date.get(.weekday) - 1] { date = date.added(.day, 1) }
    
        return date
    }
}

class Alarms: Codable
{
    var list: [Alarm] = []
    
    /// Save alarms to local storage
    func localSave()
    {
        localStorage.setValue(JSON.stringify(list)!, forKey: "alarms")
        
        // Reload table view
        if let table = AlarmViewController.staticTable { table.reloadData() }
    }
    
    /// Read alarms from local storage
    func localRead() { list = JSON.parse([Alarm].self, localStorage.string(forKey: "alarms")!)! }
    
    /// Read an alarm object from local storage
    static func fromLocal() -> Alarms { return Alarms().apply { $0.localRead() } }
    
    /// Get enabled alarms
    var listEnabled: [Alarm] { return list.filter { $0.enabled } }
    
    /// Get alarms that should be activating now
    var listActivating: [Alarm]
    {
        let now = Date()
        return listEnabled.filter { guard let n = $0.nextActivate else { return false }; return n < now }
    }
}
