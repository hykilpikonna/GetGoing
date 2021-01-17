//
//  Utils.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/17/21.
//

import Foundation

extension Date
{
    /// Add toString to Date
    func str() -> String
    {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return f.string(from: self)
    }
    
    /// Get year, month, day
    func getYMD() -> (y: Int, m: Int, d: Int)
    {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day], from: self)
        return (comp.year!, comp.month!, comp.day!)
    }
}
