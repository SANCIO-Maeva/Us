//
//  ForgotPasswordView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var mail: String = "hiboux@gmailk.com"
    @State private var phone: String = "0689898987"
    
    @State private var authenticationSucceed: Bool = false
    @State private var authenticationFail: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Mot de Passe oublié ?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Font"))
                        
                        Text("Vérifiez votre email et votre numéro de téléphone")
                            .font(.caption)
                            .fontWeight(.light)
                            .padding(.bottom, 40)
                        
                        CustomTextField(placeholder: "Téléphone", text: $phone, keyboard: .numberPad)
                        CustomTextField(placeholder: "Email", text: $mail, keyboard: .emailAddress)
                        
                        if authenticationFail {
                            Text("Information incorrecte.")
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        Us.authenticateForgotUser(mail: mail, phone: phone) { success, errorMessage in
                            authenticationSucceed = success
                            authenticationFail = !success
                        }
                    }) {
                        ButtonContent(title: "Vérifier")
                    }
                    NavigationLink(
                        destination: UpdatePassword().navigationBarBackButtonHidden(true),
                        isActive: $authenticationSucceed
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .padding()
            }
            .background(Color(.systemGray6).opacity(0.2))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UpdatePassword: View {
    @State private var password: String = ""
    @State private var confirmedpassword: String = ""
    @State private var userId: Int?
    
    @State private var authenticationFail: Bool = false
    @State private var authenticationSucceed: Bool = false
    @State private var errorMessage: String? = nil
    @State private var navigateToContent = false
    
    private func loadUserProfile() {
        if let user = UserDefaults.standard.user(forKey: "User") {
            userId = user.id
        } else {
            print("Aucun utilisateur connecté")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack( spacing: 20) {
                        Text("Réinitialiser le mot de passe")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Font"))
                            .padding(.bottom, 40)
                        
                        SecureCustomField(placeholder: "Nouveau mot de passe", text: $password)
                        SecureCustomField(placeholder: "Confirmer le mot de passe", text: $confirmedpassword)
                        
                        if authenticationFail {
                            Text(errorMessage ?? "Les mots de passe ne sont pas identiques.")
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        guard password == confirmedpassword else {
                            authenticationFail = true
                            errorMessage = "Les mots de passe ne sont pas identiques."
                            return
                        }
                        
                        guard let id = userId else {
                            authenticationFail = true
                            errorMessage = "Utilisateur introuvable."
                            return
                        }

                        Us.updatePassword(id: id, password: password) { success, message in
                            DispatchQueue.main.async {
                                if success {
                                    authenticationFail = false
                                    authenticationSucceed = success
                                } else {
                                    authenticationFail = true
                                    errorMessage = message
                                }
                            }
                        }
                    }) {
                        ButtonContent(title: "Valider")
                    }

                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $navigateToContent) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6).opacity(0.2))
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $authenticationSucceed) {
                Alert(
                    title: Text("Mise à jour réussie 🎉"),
                    message: Text("Votre mot de passe a bien été modifié !"),
                    dismissButton: .default(Text("OK"), action: {
                        navigateToContent = true
                    })
                )
            }
            .onAppear(perform: loadUserProfile)
        }
    }
}
