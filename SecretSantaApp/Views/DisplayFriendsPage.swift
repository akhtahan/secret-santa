//
// DisplayFriendsPage.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-12-09.
// 
//
// 
//

import SwiftUI

struct DisplayFriendsPage: View {
    var userToDelete: User?
    @EnvironmentObject var dbHelper: FireDBHelper

    var body: some View {
        NavigationView {
            VStack{
                
                if (dbHelper.currentUser?.friendsList == nil || dbHelper.currentUser?.friendsList?.isEmpty == true) {
                    VStack {
                        Image("santa")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 120)
                            .padding(.vertical, 32)
                        
                        Text("No friends added!")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .navigationBarHidden(true)
                } else {
                    List {
                        ForEach(dbHelper.currentUser?.friendsList ?? [], id: \.id) { friend in
                            HStack {
                                Image(systemName: "person.fill.checkmark")
                                    .foregroundColor(.green)
                                    .imageScale(.medium)
                                Text(friend.username ?? "NA")
                                    .font(.headline)
                            }
                        }
                        .onDelete { indices in
                            if let index = indices.first {
                                if let userToDelete = dbHelper.currentUser?.friendsList?[index] {
                                    deleteFriend(user: userToDelete)
                                    dbHelper.currentUser?.friendsList?.remove(at: index)
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .onAppear {
                        print("DisplayFriendsPage appeared")
                        print("Friends List: \(dbHelper.currentUser?.friendsList ?? [])")
                    }
                    .navigationTitle("My Friends")
                }
            }//Vstack
                
                    .navigationBarItems(trailing:
                        NavigationLink(destination: FriendsPageView().environmentObject(dbHelper)) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    )

                
                
           // }//vstack
        }//NavigationView
    }

    func deleteFriend(user: User) {
        self.dbHelper.deleteFriend(userToDelete: user) {
            print("Friend deleted successfully.")
        }
    }
}


//struct DisplayFriendsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayFriendsPage()
//    }
//}
