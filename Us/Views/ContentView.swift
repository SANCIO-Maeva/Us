//
//  ContentView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI
//import Foundation

struct ContentView: View {
    
    @State private var mail: String = "john.doe@example.com"
    @State private var password: String = "Azerty7513!"
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var authenticationFail: Bool = false
    @State private var authenticationSucceed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HelloText()
                    MailTextField(mail: $mail)
                    PasswordSecureField(password: $password)
                    HStack{
                        Spacer()
                        NavigationLink("Mot de passe oublié ?", destination: ForgotPasswordView())
                            .font(.caption)
                            .fontWeight(.light)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    if authenticationFail{
                        Text("Information incorrecte.")
                            .offset(y:-10)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        Us.authenticateUser(mail: mail, password: password) { success, errorMessage  in
                            authenticationSucceed = success
                            authenticationFail = !success
                        }
                    }){
                        LoginButtonContent()
                    }
                    NavigationLink("Créer un nouveau compte", destination: SignUpView())
                        .font(.caption)
                        .fontWeight(.light)
                        .padding()
                }
                .padding()
                if authenticationSucceed{
                    NavigationView{HomeView()}
                }
            }
        }
        .navigationBarHidden(true)
    }
}


struct HelloText: View {
    var body: some View {
        Text("Bienvenue!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 20)
        Text("La solidarité commence ici. Connectez-vous!")
            .font(.caption)
            .fontWeight(.light)
            .padding(.bottom, 80)
    }
}

struct LoginButtonContent: View {
    var body: some View {
        Text("Connexion")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 350, height: 60)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal, 20)
    }
}

struct MailTextField: View {
    
    @Binding var mail: String
    
    var body: some View {
        TextField(("Email"), text: $mail)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
            .padding(.horizontal, 20)
    }
}

struct PasswordSecureField: View {
    
    @Binding var password: String
    
    var body: some View {
        SecureField(("Mot de passe"), text: $password)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
            .padding(.horizontal, 20)
    }
}
