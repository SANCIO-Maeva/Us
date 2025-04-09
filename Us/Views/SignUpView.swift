//
//  SignUpView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var name: String = "Coca-Cola"
    @State private var firstname: String = "Cherry"
    @State private var address: String = "11 rue gambetta"
    @State private var phone: String = "0698765433"
    @State private var mail: String = "cocacola@gmail.com"
    @State private var password: String = "Qwerty12!"
    @State private var postalCode: String = "94800"
    @State private var bio: String = "Je sui un oiseux de nuit qui veut être un oiseau de jour. La discretion est ma meilleure armure. Je suis un predateur qui ne se laisse pas abattre."
    private var latitude: String = ""
    private var longitude: String = ""
    private var id_user: Int? = nil
    @State private var authenticationFail: Bool = false
    @State private var authenticationSucceed: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                NewText()
                
                HStack(spacing: 10) {
                    NameTextField(name: $name)
                    FirstnameTextField(firstname: $firstname)
                }
                AddressTextField(address: $address)
                PhoneTextField(phone: $phone)
                MailTextField(mail: $mail)
                PasswordSecureField(password: $password)
                PostalCodeTextField(postalCode: $postalCode)
                BioTextField(bio: $bio)
                    .padding(.bottom)
                
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
                            name: name,
                            firstname: firstname,
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
                    SignUpButtonContent()
                }
                
                
                NavigationLink("J'ai déjà un compte", destination: ContentView())
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }
            .padding()
            
            if authenticationSucceed {
                NavigationView { HomeView() }
            }
            
            if authenticationFail {
                Text(errorMessage ?? "Erreur inconnue.")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SignUpView()
}

struct NewText: View {
    var body: some View {
        Text("Nous Rejoindre ?")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
        Text("Rejoignez une communoté qui d'entraide au quotidien !")
            .font(.caption)
            .fontWeight(.light)
            .padding(.bottom, 60)
    }
}

struct SignUpButtonContent: View {
    var body: some View {
        Text("Inscription")
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

struct NameTextField: View {
    
    @Binding var name: String
    
    var body: some View {
        TextField(("Nom"), text: $name)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
            .padding(.leading, 20)
    }
}

struct FirstnameTextField: View {
    
    @Binding var firstname: String
    
    var body: some View {
        TextField(("Prénom"), text: $firstname)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
            .padding(.trailing,20)
    }
}


struct AddressTextField: View {
    
    @Binding var address: String
    
    var body: some View {
        TextField(("Adresse"), text: $address)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
            .padding(.horizontal,20)
    }
}

struct PhoneTextField: View {
    
    @Binding var phone: String
    
    var body: some View {
        TextField(("Téléphone"), text: $phone)
            .keyboardType(.numberPad)
            .padding()
            .background(RoundedRectangle(cornerRadius:8).fill(Color(.systemGray6)))
            .padding(.horizontal, 20)
    }
}

struct PostalCodeTextField: View {
    
    @Binding var postalCode: String
    
    var body: some View {
        TextField("Code Postal", text: $postalCode)
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 10)
    }
}

struct BioTextField: View {
    @Binding var bio: String
    var body: some View {
        TextField("Biographie", text: $bio)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 10)
    }
}
