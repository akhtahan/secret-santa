//
// SignUpView.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-29.
// 
//
// 
//


import SwiftUI

import FirebaseAuth

struct SignUpView: View {
    
    @Binding var rootView : RootView
    @EnvironmentObject var dbHelper : FireDBHelper

    @State private var email : String = ""
    @State private var password : String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {

        VStack{
            
            Spacer()

            
            Image("santa")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            Text("Secret Santa")
                .font(.title)
                        
            TextField("username", text: $email)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
                SecureField("password", text: $password)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            
                Button(action: {
                    
                    self.createAccount()
                }){
                    Text("Create Account")
                        .padding(EdgeInsets(top: 6, leading: 5, bottom: 6, trailing: 5))
                        .frame(maxWidth: .infinity)
                    
                }
                .buttonStyle(.borderedProminent)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.top, 24)
                .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Error"),
                                    message: Text(alertMessage),
                                    dismissButton: .default(Text("OK")) {
                                        showAlert = false
                                    }
                                )
                            }

            
            Button(action: {
                // Set rootView to .login to navigate to login page
                self.rootView = .login
            }) {
                Text("Already have an account? Log In")
                    .foregroundColor(.blue)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                showAlert = false
                }
            )
        }
    }//body
    
    private func createAccount() {
        //for case-insensitive comparison
        let lowercaseEmail = self.email.lowercased()

        //check if user already exists in the user list
        if let existingUser = self.dbHelper.userList.first(where: { ($0.username?.lowercased() ?? "") == lowercaseEmail }) {
            print("User with email '\(self.email)' already exists.")
            showAlert = true
            alertMessage = "An account with this email already exists."
            return
        }

        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            guard let result = authResult else {
                print(#function, "Unable to create user due to error : \(error)")
                showAlert = true
                alertMessage = "Error creating account. Please try again."
                return
            }

            print(#function, "authResult : \(authResult)")

            switch authResult {
            case .none:
                print(#function, "Account creation denied")
                showAlert = true
                alertMessage = "Account creation denied. Please try again."
            case .some(_):
                print(#function, "Account creation successful")

                if let email = authResult?.user.email {
                    print(#function, "user info Email : \(email)")
                    UserDefaults.standard.set(email, forKey: "KEY_EMAIL")
                    UserDefaults.standard.set(authResult!.user.uid, forKey: "KEY_USER_ID")

                    self.rootView = .main
                    print(#function, "root view: \(self.rootView)")

                    let newUser = User(id: authResult?.user.uid ?? "NA", username: email)
                    self.dbHelper.insertUser(user: newUser)

                    
                }
            }
        }
    }



}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
