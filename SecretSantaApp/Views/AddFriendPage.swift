//
// AddFriendPage.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-12-09.
// 
//
// 
//

import SwiftUI

struct AddFriendPage: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    var user: User
    let userId = UserDefaults.standard.string(forKey: "KEY_USER_ID") ?? "NA"
    @State private var isDisplayFriendsPageActive = false

    var body: some View {
        VStack(spacing: 16) {
            Text(user.username ?? "NA")
                .font(.title)
                .fontWeight(.bold)

            Button(action: {
                addFriend()
                isDisplayFriendsPageActive = true
            }) {
                Text("Add Friend")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(isFriendAlreadyAdded())
            .opacity(isFriendAlreadyAdded() ? 0.5 : 1.0)
            .overlay(isFriendAlreadyAdded() ? Color.gray.opacity(0.3) : Color.clear)
            
            NavigationLink(
                destination: DisplayFriendsPage().environmentObject(dbHelper),
                isActive: $isDisplayFriendsPageActive,
                label: {
                    EmptyView()
                }
            )
            .hidden()
        }
        .padding()
    }

    func addFriend() {
        self.dbHelper.insertFriend(user: user) {
            print("Friend addition process complete.")
        }
        self.dbHelper.currentUser?.friendsList?.append(user)
        print("friends list: \(dbHelper.currentUser?.friendsList)")
    }

    func isFriendAlreadyAdded() -> Bool {
        return (dbHelper.currentUser?.friendsList ?? []).contains(user)
    }
}
