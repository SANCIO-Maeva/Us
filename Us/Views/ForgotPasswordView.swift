//
//  ForgotPasswordView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var mail: String = "john.doe@example.com"
    @State private var phone: String = "1234567890"
    
    @State private var authenticationSucceed: Bool = false
    @State private var authenticationFail: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Mot de Passe oublié ?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("SkyBlue"))
                        
                        Text("Vérifiez votre email et votre numéro de téléphone")
                            .font(.caption)
                            .fontWeight(.light)
                            .padding(.bottom, 40)
                        
                        VerifyMailTextField(mail: $mail)
                        VerifyPhoneTextField(phone: $phone)
                        
                        if authenticationFail {
                            Text("Information incorrecte.")
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 12) {
                    GradientButton(
                        title: "Vérifier",
                        colors: [Color(.cyan), Color(.mint)]
                    ) {
                        Us.authenticateForgotUser(mail: mail, phone: phone) { success, errorMessage in
                            authenticationSucceed = success
                            authenticationFail = !success
                        }
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
                .background(Color.white.ignoresSafeArea(edges: .bottom))
            }
            .background(Color(.systemGray6).opacity(0.2))
            .navigationTitle("Réinitialisation du mot de passe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UpdatePassword: View {
    @State private var password: String = "Azerty7513!"
    @State private var confirmedpassword: String = "Azerty7513!"
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
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Réinitialiser le mot de passe")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("SkyBlue"))
                        
                        SecureField("Nouveau mot de passe", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                            .padding(.horizontal, 20)
                        
                        SecureField("Confirmer le mot de passe", text: $confirmedpassword)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                            .padding(.horizontal, 20)
                        
                        if authenticationFail {
                            Text(errorMessage ?? "Les mots de passe ne sont pas identiques.")
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 12) {
                    GradientButton(
                        title: "Valider",
                        colors: [Color(.cyan), Color(.mint)]
                    ) {
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
                    }
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $navigateToContent) {
                        EmptyView()
                    }
                }
                .padding()
                .background(Color.white.ignoresSafeArea(edges: .bottom))
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

// MARK: - Sous-vues

struct VerifyMailTextField: View {
    @Binding var mail: String
    var body: some View {
        TextField("Email", text: $mail)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
            .padding(.horizontal, 20)
    }
}

struct VerifyPhoneTextField: View {
    @Binding var phone: String
    var body: some View {
        TextField("Téléphone", text: $phone)
            .keyboardType(.phonePad)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
    }
}
