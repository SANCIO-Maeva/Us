//
//  SignUpView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var fullname: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var postalCode: String = ""
    @State private var bio: String = ""
    private var latitude: String = ""
    private var longitude: String = ""
    private var id_user: Int? = 0
    @State private var authenticationFail: Bool = false
    @State private var authenticationSucceed: Bool = false
    @State private var errorMessage: String? = nil
    @State private var navigateToContent = false
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Nous Rejoindre ?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                        .multilineTextAlignment(.center)
                    
                    Text("Rejoignez une communauté d'entraide au quotidien !")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    Group {
                        CustomTextField(placeholder: "Nom et prénom", text: $fullname)
                        CustomTextField(placeholder: "Adresse", text: $address)
                        CustomTextField(placeholder: "Téléphone", text: $phone, keyboard: .numberPad)
                        CustomTextField(placeholder: "Email", text: $mail, keyboard: .emailAddress)
                        SecureCustomField(placeholder: "Mot de passe", text: $password)
                        CustomTextField(placeholder: "Code Postal", text: $postalCode, keyboard: .numberPad)
                        CustomTextField(placeholder: "Biographie", text: $bio)
                    }
                    
                    if authenticationFail {
                        Text(errorMessage ?? "Erreur inconnue.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        fetchCoordinates(for: address) { latitude, longitude, error in
                            if let error = error {
                                authenticationFail = true
                                authenticationSucceed = false
                                errorMessage = error
                                return
                            }
                            
                            guard let latitude = latitude, let longitude = longitude else {
                                authenticationFail = true
                                authenticationSucceed = false
                                errorMessage = "Impossible de récupérer les coordonnées GPS."
                                return
                            }
                            
                            createUser(
                                id_user: id_user!,
                                fullname: fullname,
                                address: address,
                                phone: phone,
                                mail: mail,
                                password: password,
                                postal_code: postalCode,
                                bio: bio,
                                latitude: "\(latitude)",
                                longitude: "\(longitude)"
                            ) { success, error in
                                authenticationSucceed = success
                                authenticationFail = !success
                                errorMessage = error
                            }
                        }
                    }) {
                        ButtonContent( title: "Inscription")
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    
                    NavigationLink(destination: ContentView(), isActive: $navigateToContent) {
                        EmptyView()
                    }

                    NavigationLink("J'ai déjà un compte", destination: ContentView())
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.bottom, 30)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $authenticationSucceed) {
            Alert(
                title: Text("Inscription réussie 🎉"),
                message: Text("Votre profil a bien été créé !"),
                dismissButton: .default(Text("OK"), action: {
                    navigateToContent = true
                })
            )
        }
    }
}
