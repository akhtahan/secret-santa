//
// User.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-19.
// 
//
// 
//

import Foundation

struct User: Identifiable, Equatable, Codable{
    
    let id: String
    let username: String?
    var name: String?
    var friendsList : [User]?
    var secretSantaOf: String?
//    var wishlist : [Wish]?
//    var wishlistOf : [Wish]?
    
    init(id: String, username: String, name: String? = nil, friends : [User]? = nil, secretSantaOf: String? = nil) {
          self.id = id
          self.username = username
          self.name = name
          self.friendsList = friends
        self.secretSantaOf = secretSantaOf
//        self.wishlist = []
//        self.wishlistOf = []
      }
    
}
