//
// SignInView.swift
// SecretSantaApp
//
// Created by Haniya Akhtar on 2023-11-29.
// 
//
// 
//


import SwiftUI
import FirebaseAuth

struct SignInView: View {
    
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
                  
                    self.login()
                }){
                    Text("Login")
                        .padding(EdgeInsets(top: 6, leading: 5, bottom: 6, trailing: 5))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.top, 24)
                
            Button(action: {
                // Set rootView to .signUp to navigate to SignUpView
                self.rootView = .signUp
            }) {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            }
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
   
    private func login() {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { authResult, error in
            guard let result = authResult else {
                print(#function, "Unable to sign in due to error : \(error)")
                showAlert = true
                alertMessage = "Invalid credentials. Please try again."
                return
            }

            print(#function, "authResult : \(authResult)")

            switch authResult {
            case .none:
                print(#function, "Unsuccessful sign-in attempt")
            case .some(_):
                print(#function, "Login successful")

                if let email = authResult?.user.email {
                    print(#function, "user info Email : \(email)")
                    print(#function, "user info Name : \(authResult!.user.displayName)")
                }

                UserDefaults.standard.set(authResult!.user.email, forKey: "KEY_EMAIL")
                UserDefaults.standard.set(authResult!.user.uid, forKey: "KEY_USER_ID")

                self.rootView = .main
                print(#function, "root view: \(rootView)")

                self.dbHelper.retrieveFriends { _ in
                    print("friends received")
                }

                print("Updated user's friendsList: \(dbHelper.currentUser?.friendsList ?? [])")
            }
        }
    }
}

//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//    SignInView (Binding<RootView>(rootView : .login))
//    }
//}
