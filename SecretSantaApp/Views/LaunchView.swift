//
// LaunchView.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-29.
// 
//
// 
//


import SwiftUI

struct LaunchView: View {
    
    @State private var rootView : RootView = .login
    
    let fireDBHelper : FireDBHelper = FireDBHelper.getInstance()
    
    var body: some View {
        NavigationStack{
            switch self.rootView{
            case .signUp:
                SignUpView(rootView: self.$rootView).environmentObject(self.fireDBHelper)
            case .login:
                SignInView(rootView: self.$rootView).environmentObject(self.fireDBHelper)
            case .main:
                MainView(rootView: self.$rootView).environmentObject(self.fireDBHelper)
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
