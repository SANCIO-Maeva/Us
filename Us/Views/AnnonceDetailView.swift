//  AnnonceDetailView.swift
//  Us
//
//  Created by Maëva SANCIO on 06/03/2025.
//

import SwiftUI

struct AnnonceDetailView: View {
    let annonce: Announcement
    let isMyAnnonce: Bool
    
    @State private var isEditing2 = false
    @State private var showAlert = false
    @State private var isMessageViewPresented = false
    
    @State private var newTitle = ""
    @State private var newDescription = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Titre
                    Text("Titre de l'annonce")
                        .font(.headline)
                        .foregroundColor(Color("SkyBlue"))
                    
                    Text(annonce.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("Peach"))
                    
                    Divider()
                    
                    // Description
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(Color("SkyBlue"))
                    
                    Text(annonce.description)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }

            // Boutons fixés en bas
            VStack(spacing: 12) {
                if isMyAnnonce {
                    GradientButton(
                        title: "Modifier l'annonce",
                        colors: [Color(.cyan), Color(.mint)]
                    ) {
                        newTitle = annonce.title
                        newDescription = annonce.description
                        isEditing2.toggle()
                    }
                    
                    Button("Supprimer l'annonce") {
                        showAlert = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.red)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                } else {
                    GradientButton(
                        title: "Envoyer un message",
                        colors: [Color(.mint), Color("Peach")]
                    ) {
                        isMessageViewPresented.toggle()
                    }
                }
            }
            .padding()
            .background(Color.white.ignoresSafeArea(edges: .bottom))
        }
        .background(Color(.systemGray6).opacity(0.2))
        .navigationTitle("Détail de l'annonce")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Êtes-vous sûr de vouloir supprimer cette annonce ?", isPresented: $showAlert) {
            Button("Annuler", role: .cancel) {}
            Button("Supprimer", role: .destructive) {
                deleteAnnounce(id_announcement: annonce.id) { success, message in
                    print(success ? "Annonce supprimée" : "Erreur : \(message ?? "Erreur inconnue")")
                }
            }
        }
        .sheet(isPresented: $isEditing2) {
            EditAnnonceView(
                title: $newTitle,
                description: $newDescription,
                isPaid: .constant(true),
                amount: .constant(""),
                onSave: {
                    updateAnnounce(id_announcement: annonce.id, title: newTitle, description: newDescription) { success, message in
                        print(success ? "Annonce mise à jour" : "Erreur : \(message ?? "Erreur inconnue")")
                    }
                }
            )
        }
        .sheet(isPresented: $isMessageViewPresented) {
            MessageView(recipientId: annonce.userId, announcementId: annonce.id)
        }
    }
}

struct EditAnnonceView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var isPaid: Bool
    @Binding var amount: String
    @Environment(\.presentationMode) var presentationMode

    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titre de l'annonce")) {
                    TextField("Titre", text: $title)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 150)
                }
                Section {
                    Toggle("Rémunération ?", isOn: $isPaid)
                    if isPaid {
                        TextField("Montant en €", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                }

            }
            .navigationTitle("Modifier l'annonce")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Enregistrer") {
                        onSave()  // Appel à la fonction de mise à jour
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}


// Vue de message
struct MessageView: View {
    
    let recipientId: Int
    let announcementId: Int

    @State private var message: String = ""
    @State private var conversationId: Int? = 0
    @State private var userIdSender : Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    private func fetchUserId() {
        if let userData = UserDefaults.standard.user(forKey: "User") {
            self.userIdSender = userData.id
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Envoyer un message à l'utilisateur")
                    .font(.headline)
                    .padding(.horizontal)
                
                TextEditor(text: $message)
                    .frame(height: 150)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    sendMessage(
                        id_message: Int.init(), // Génération d'un ID aléatoire
                        content: message,
                        userIdSender: userIdSender,
                        userIdReceiver: recipientId,
                        announcementId: announcementId,
                        conversationId: conversationId!,
                        timestamp: Date(),
                        completion: { success, error in
                            if success {
                                print("Message envoyé")
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Erreur: \(error ?? "Erreur inconnue")")
                            }
                        }
                    )
                }) {
                    Text("Envoyer")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .navigationTitle("Envoyer un message")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .onAppear {
                        fetchUserId()
                    }
                }
            }
        }
    }
}

struct GradientButton: View {
    var title: String
    var colors: [Color]
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(gradient: Gradient(colors: colors),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .cornerRadius(12)
                .shadow(radius: 5)
        }
    }
}

