//
//  ContentView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var mail: String = "hiboux@gmail.com"
    @State private var password: String = "Hiboux123!"
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var authenticationFail: Bool = false
    @State private var authenticationSucceed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("Image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Text("Bienvenue!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    Text("La solidarité commence ici. Connectez-vous!")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.bottom, 80)
                    CustomTextField(placeholder: "Email", text: $mail, keyboard: .emailAddress)
                    SecureCustomField(placeholder: "Mot de passe", text: $password)
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
                        ButtonContent(title: "Connexion")
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
