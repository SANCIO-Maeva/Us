//
//  SignUpView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var fullname: String = "Kipling Hiboux"
    @State private var address: String = "40 rue des terres au curé"
    @State private var phone: String = "0689898989"
    @State private var mail: String = "hiboux@gmail.com"
    @State private var password: String = "Hiboux123!"
    @State private var postalCode: String = "75013"
    @State private var bio: String = "je suis un oiseaux de nuit qui sait tout faire"
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
                        Text("Inscription")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.6, green: 0.8, blue: 1.0), Color(red: 0.7, green: 1.0, blue: 0.9)]),
                                startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(12)
                            .shadow(radius: 4)
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
