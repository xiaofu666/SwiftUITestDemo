//
//  Task.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/23.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = .init()
    var dateAdded: Date
    var taskName: String
    var taskDescription: String
    var taskCategory: Category
}


var SampleTasks: [Task] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1677160038), taskName: "学习编程", taskDescription: "完事睡觉", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1677156738), taskName: "Edit YT Video", taskDescription: "ceshi", taskCategory: .general)
]

enum Category: String,CaseIterable {
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case modifiers = "Modifiers"
    case challenge = "Challenge"
    case coding = "Coding"
    
    var color: Color {
        switch self {
        case .general:
            return Color("Gray")
        case .bug:
            return Color("Green")
        case .idea:
            return Color("Pink")
        case .modifiers:
            return Color("Blue")
        case .challenge:
            return Color("Purple")
        case .coding:
            return Color.brown
        }
    }
}
