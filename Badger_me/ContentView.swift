//
//  ContentView.swift
//  Badger_me
//
//  Created by Jakub Rozak on 07/09/2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    @AppStorage("log_Status") var log_Status = false
    var body: some View {
        
        if log_Status{

            NavigationView{
                VStack(spacing:15){
                    Text("youre Logged in")

                    Button("Logout"){
                        GIDSignIn.sharedInstance.signOut(); try? Auth.auth().signOut()

                        withAnimation{
                            log_Status = false
                        }
                    }
                }
            }
        } else {
            LoginPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
