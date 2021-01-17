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

struct Alarm: Codable
{
    var enabled: Bool
    var hour: Int // Hour (24)
    var minute: Int
    var text: String
    var wakeMethod: WVM
    
    /// What days does it repeat (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
    var repeats: [Bool] = [false, true, true, true, true, true, false]
    
    /// Does it automatically disable after activating once
    var autoDisable = true
    
    /// When is the last time that the alarm went off
    var lastActivate: Date? = nil
    
}

class Alarms: Codable
{
    var list: [Alarm] = []
    
    /// Save alarms to local storage
    func localSave() -> Alarms { localStorage.setValue(JSON.stringify(list)!, forKey: "alarms"); return self }
    
    /// Read alarms from local storage
    func localRead() -> Alarms { list = JSON.parse([Alarm].self, localStorage.string(forKey: "alarms")!)!; return self }
    
    /// Read an alarm object from local storage
    static func fromLocal() -> Alarms { return Alarms().localRead() }
    
    /// Get enabled alarms
    var listEnabled: [Alarm] { return list.filter { $0.enabled } }
}
