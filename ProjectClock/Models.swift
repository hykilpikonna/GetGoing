//
//  Models.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/12/21.
//

import Foundation

struct User: Decodable
{
    var id: Int
    var name: String
    var email: String
    var pass: String
}

struct Family: Decodable
{
    var fid: Int
    var fname: String
    var members: [String]
    // And a hidden field: admin pin
}
