//
//  Intro.swift
//  IntroAnimation1216
//
//  Created by 张亚飞 on 2022/12/16.
//

import SwiftUI

struct Intro: Identifiable {
    var id: String = UUID().uuidString
    var imageName: String
    var title: String
}

var intros: [Intro] = [
    .init(imageName: "Book 1", title: "Relax"),
    .init(imageName: "Book 2", title: "Care"),
    .init(imageName: "Book 3", title: "Mood Dairy")
]


let sansBold = "WorkSans-Bold"
let sansSemiBold = "WorkSans-SemiBold"
let sansRegular = "WorkSans-Regular"

let dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. \nLorem Ipsum is dummy text."
