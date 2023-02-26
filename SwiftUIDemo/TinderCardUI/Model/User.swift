//
//  User.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/19.
//

import SwiftUI

struct User: Identifiable {
    var id = UUID().uuidString
    var name: String
    var place: String
    var profilePic: String
}
