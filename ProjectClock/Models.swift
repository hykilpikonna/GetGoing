//
//  Models.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/12/21.
//

import Foundation

struct User: Codable
{
    var id: Int
    var name: String
    var email: String
    var pass: String
}

struct Family: Codable
{
    var fid: Int
    var fname: String
    var members: [String]
    // And a hidden field: admin pin
}

struct WVM: Codable
{
    let name: String
    let desc: String
}

let wvms = [
    WVM(name: "Walk", desc: "Walk a few steps"),
    WVM(name: "Jump", desc: "Make a few jumps"),
    WVM(name: "Puzzle", desc: "Complete a simple puzzle"),
    WVM(name: "Smash", desc: "It'll never truns off"),
]

class Alarm: Codable
{
    var enabled: Bool
    var hour: Int // Hour (24)
    var minute: Int
    var text: String
    var wakeMethod: WVM
    
    /// What days does it repeat (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
    var repeats: [Bool]
    
    /// Does it automatically disable after activating once
    var oneTime: Bool
    
    /// When is the last time that the alarm went off
    var lastActivate: Date
    
    /// Constructor
    init(enabled: Bool = true,
         hour: Int, minute: Int, text: String, wakeMethod: WVM,
         repeats: [Bool] = [false, true, true, true, true, true, false],
         oneTime: Bool = false, lastActivate: Date = Date()
    )
    {
        self.enabled = enabled
        self.hour = hour
        self.minute = minute
        self.text = text
        self.wakeMethod = wakeMethod
        self.repeats = repeats
        self.oneTime = oneTime
        self.lastActivate = lastActivate
    }
    
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
        while !repeats[date.get(.weekday)] { date = date.added(.day, 1) }
    
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
