//
//  LoginPage.swift
//  Badger_me2
//
//  Created by Jakub Rozak on 06/09/2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginPage: View {
    
    //Loading indicator
    @State var isLoading: Bool = false
    
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        VStack {
        Image("rb_logo1")
        
        Text("BadgerMe is used to scheadule events and activities with other badgers")
            .font(.largeTitle)
            .fontWeight(.light)
            .kerning(1.1)
            .foregroundColor(Color.black.opacity(0.8))
            .multilineTextAlignment(.center)
        VStack(spacing:20){
            Button{
                handleLogin()
            } label: {
                HStack(spacing: 15){
                    Image("google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 65.0, height: 65.0)
                    Text("Login with Google")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .kerning(1.1)
                }
                .foregroundColor(Color("Blue"))
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Capsule().strokeBorder(Color.blue)
                )
            }
            
        }
        .padding(.top,20.0)
        }
        .frame(maxWidth: .infinity,maxHeight:
                .infinity,alignment: .top
        )
        .overlay(
            ZStack {
                if isLoading{
                    Color.black
                         .opacity(0.25)
                         .ignoresSafeArea()
                    
                    ProgressView()
                        .font(.title2)
                        .frame(width: 60, height: 60 )
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
            }
        )
    }
    func handleLogin(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {[self] user, err in
            if let error = err {
                isLoading = false
                print(error.localizedDescription)
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
              else {
                isLoading = false
                return
              }

              let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential){
                result, err in
                
                isLoading = false
                
                if let error = err {
                    print(error.localizedDescription)
                }
                
                guard let user = result?.user else{
                    return
                }
                print(user.displayName ?? "Succes!")
                
                //update user as logged in
                withAnimation{
                    log_Status = true
                }
            }
            
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    //retreving RootView
    
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}

