//
// FriendsPage.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-19.
// 
//
// 
//

import SwiftUI

struct FriendsPageView: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            if (dbHelper.currentUser?.friendsList?.count == dbHelper.userList.count) {
                VStack {
                    Image("santa")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .padding(.vertical, 32)

                    Text("No friends to add!")
                        .font(.headline)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
            } else {
                VStack {
                    List {
                        ForEach(self.dbHelper.userList.filter { user in
                            let isCurrentUser = user.username == UserDefaults.standard.string(forKey: "KEY_EMAIL")
                            let matchesSearchText = self.searchText.isEmpty || ((user.username?.localizedCaseInsensitiveContains(self.searchText)) != nil)

                            let isNotCurrentUser = !isCurrentUser
                            let isNotInFriendsList = !(self.dbHelper.currentUser?.friendsList ?? []).contains(user)

                            return isNotCurrentUser && isNotInFriendsList && matchesSearchText
                        }, id: \.id) { user in
                            NavigationLink(destination: AddFriendPage(user: user).environmentObject(dbHelper)) {
                                HStack {
                                    Image(systemName: "person.fill.badge.plus")
                                        .foregroundColor(.blue) 
                                        .imageScale(.medium)
                                    Text(user.username ?? "NA")
                                        .font(.headline)
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                .padding()
                .navigationTitle("Search For Friends")
                .searchable(text: self.$searchText, prompt: "Search by username")
            }
        }
    }
}
