//
// MainView.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-29.
// 
//
// 
//


import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    @Binding var rootView : RootView
    @EnvironmentObject var dbHelper : FireDBHelper
    @ObservedObject private var placesViewModel = PlacesViewModel()

    @State private var searchText : String = ""
    
    var body: some View {
            VStack{
                TabView{
                    DisplayFriendsPage().tabItem{
                        Image(systemName: "heart.fill")
                        Text("Friends")
                    }.environmentObject(self.dbHelper)

                    ExchangePage().tabItem{
                        Image(systemName: "gift.fill")
                        Text("Exchange Gifts")
                    }.environmentObject(self.dbHelper)
                    
                    ShopsPage(places: placesViewModel.places).tabItem{
                        Image(systemName: "location.circle.fill")
                        Text("Shops")
                    }
                }//TabView
            }//VStack
            .navigationBarItems(trailing:
            Button(action: {
                logout()
            }) {
                Image(systemName: "person.crop.circle.badge.xmark")
                    .font(.title)
                    .foregroundColor(.blue) 
            }
            )
    }//body
    
    private func logout(){
        do{
            try Auth.auth().signOut()
            
            self.rootView = .login
            
        }catch let err as NSError{
            print(#function, "Unable to sign out : \(err)")
        }
    }
    
}//struct

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(rootView: RootView())
//    }
//}
