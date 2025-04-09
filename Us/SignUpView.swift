//
//  SignUpView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//
import SwiftUI

struct SignUpView: View {
    
    @State var name: String = ""
    @State var firstname: String = ""
    @State var address: String = ""
    @State var phone: String = ""
    @State var mail: String = ""
    @State var password: String = ""
    
    @State var authenticationFail: Bool = false
    @State var authenticationSucceed: Bool = false
    @State var errorMessage: String? = nil
    
    var body: some View {
        ZStack{
            VStack{
                NewText()
                HStack{
                    NameTextField(name: $name)
                    FirstnameTextField(firstname: $firstname)
                }
                AddressTextField(address: $address)
                PhoneTextField(phone: $phone)
                NewMailTextField(mail: $mail)
                NewPasswordSecureField(password: $password)
                
                Button(action: {
                    createUser()
                }) {
                    SignUpButtonContent()
                }
                NavigationLink("J'ai déjà un compte", destination: ContentView())
                    .navigationBarHidden(true)
                    .font(.caption)
                    .fontWeight(.light)
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
    }
    
    func createUser() {
        guard let url = URL(string: "http://localhost:3000/v1/users") else { return }
        
        let userData = [
            "name": name,
            "firstname": firstname,
            "address": address,
            "phone": phone,
            "mail": mail,
            "password": password,
            "role": "Admin",  // Remplacer si nécessaire
            "city": "Paris",  // Remplacer si nécessaire
            "country": "France"  // Remplacer si nécessaire
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.authenticationFail = true
                    self.errorMessage = "Erreur de connexion: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.authenticationFail = true
                    self.errorMessage = "Aucune réponse du serveur."
                }
                return
            }
            
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = responseJSON as? [String: Any], let user = responseDict["user"] as? [String: Any] {
                    DispatchQueue.main.async {
                        self.authenticationSucceed = true
                        self.authenticationFail = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.authenticationFail = true
                        self.errorMessage = "Erreur lors de la création de l'utilisateur."
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.authenticationFail = true
                    self.errorMessage = "Erreur de traitement des données."
                }
            }
        }.resume()
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
            .frame(width: 250, height: 60)
            .background(Color.black)
            .cornerRadius(35.0)
            .padding(.vertical,20)
    }
}

struct NameTextField: View {
    
    @Binding var name: String
    
    var body: some View {
        TextField(("Nom"), text: $name)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct FirstnameTextField: View {
    
    @Binding var firstname: String
    
    var body: some View {
        TextField(("Prénom"), text: $firstname)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct AddressTextField: View {
    
    @Binding var address: String
    
    var body: some View {
        TextField(("Adresse"), text: $address)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct PhoneTextField: View {
    
    @Binding var phone: String
    
    var body: some View {
        TextField(("Téléphone"), text: $phone)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct NewMailTextField: View {
    
    @Binding var mail: String
    
    var body: some View {
        TextField(("Email"), text: $mail)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct NewPasswordSecureField: View {
    
    @Binding var password: String
    
    var body: some View {
        SecureField(("Mot de passe"), text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
