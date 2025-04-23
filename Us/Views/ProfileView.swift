//
//  ProfileView.swift
//  Us
//
//  Created by Maëva SANCIO on 05/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @State private var fullname: String = ""
    @State private var bio: String = ""
    @State private var mail: String = ""
    @State private var phone: String = ""
    @State private var isEditing: Bool = false
    
    private func fetchUserProfile() {
        if let userData = UserDefaults.standard.data(forKey: "User"),
           let userDict = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: Any] {
            
            fullname = userDict["fullname"] as? String ?? ""
            bio = userDict["bio"] as? String ?? ""
            mail = userDict["mail"] as? String ?? ""
            phone = userDict["phone"] as? String ?? ""
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
                    .padding(.top, 30)
                    .shadow(radius: 5)
                HStack {
                    Text(fullname)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                }
                
                Text(bio)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            .padding()
            
            Divider()
                .padding(.vertical, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                InfoRow(icon: "envelope", text: mail)
                InfoRow(icon: "phone", text: phone)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            VStack(spacing: 15) {
                GradientButton(
                    title: "Modifier l'annonce",
                    colors: [Color(.cyan), Color(.mint)]
                ){
                    isEditing.toggle()
                }
                Button(action: logout) {
                    Text("Se déconnecter")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .tint(.red)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isEditing) {
            EditProfileView(bio: $bio, mail: $mail, phone: $phone)
        }
        .onAppear {
            fetchUserProfile()
        }
    }
}

struct InfoRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

struct EditProfileView: View {
    @Binding var bio: String
    @Binding var mail: String
    @Binding var phone: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bio")) {
                    TextField("Bio", text: $bio)
                }
                Section(header: Text("Email")) {
                    TextField("Email", text: $mail)
                }
                Section(header: Text("Téléphone")) {
                    TextField("Téléphone", text: $phone)
                }
            }
            .navigationTitle("Modifier le profil")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Enregistrer") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

