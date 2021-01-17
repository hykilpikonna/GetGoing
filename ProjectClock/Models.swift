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
    var alarmTime: Date
    var text: String
    var wakeMethod: WVM
}

struct Family: Codable
{
    var fid: Int
    var fname: String
    var members: [String]
    // And a hidden field: admin pin
}
