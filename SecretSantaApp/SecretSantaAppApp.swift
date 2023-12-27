//
// SecretSantaAppApp.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-19.
// 
//
// 
//


import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct SecretSantaAppApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
    }
}
