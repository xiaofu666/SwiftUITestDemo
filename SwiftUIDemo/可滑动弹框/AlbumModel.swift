//
//  AlbumModel.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/13.
//

import SwiftUI

struct AlbumModel: Identifiable {
    var id = UUID().uuidString
    var albumName: String
    var albumImage: String
    var isLike: Bool = false
}

var albums: [AlbumModel] = [
    AlbumModel(albumName: "Positions", albumImage: "user1"),
    AlbumModel(albumName: "The Best", albumImage: "user2", isLike: true),
    AlbumModel(albumName: "My Everything", albumImage: "user3"),
    AlbumModel(albumName: "Your Turly", albumImage: "user4"),
    AlbumModel(albumName: "Sweetener", albumImage: "user5", isLike: true),
    AlbumModel(albumName: "Rain On Me", albumImage: "user6"),
    AlbumModel(albumName: "Struck With U", albumImage: "user3"),
    AlbumModel(albumName: "Seven Things", albumImage: "user5", isLike: true),
    AlbumModel(albumName: "Bang Bang", albumImage: "user4"),
]
