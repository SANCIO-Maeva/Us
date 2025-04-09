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
    
    // Ajouter un état pour les nouvelles valeurs
    @State private var newTitle = ""
    @State private var newDescription = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(annonce.title)
                .font(.title)
                .bold()
                .padding(.top)

            Text(annonce.description)
                .font(.body)
                .foregroundColor(.gray)

            Spacer()

            if isMyAnnonce {
                Button(action: {
                    newTitle = annonce.title
                    newDescription = annonce.description
                    isEditing2.toggle()
                }) {
                    Text("Modifier l'annonce")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                }

                Button("Supprimer l'annonce") {
                    showAlert = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .tint(.red)
            } else {
                Button("Envoyer un message") {
                    isMessageViewPresented.toggle()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
            }
        }
        .padding()
        .navigationTitle("Détail de l'annonce")
        .alert("Êtes-vous sûr de vouloir supprimer cette annonce ?", isPresented: $showAlert) {
            Button("Annuler", role: .cancel) {}
            Button("Supprimer", role: .destructive) {
                deleteAnnounce(id_announcement: annonce.id) { success, message in
                    if success {
                        print("Annonce supprimée avec succès")
                    } else {
                        print("Erreur de suppression: \(message ?? "Erreur inconnue")")
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing2) {
            EditAnnonceView(title: $newTitle,
                            description: $newDescription,
                            isPaid: .constant(true),
                            amount: .constant(""),
                            onSave: {
                                // Appel à updateAnnounce lors de la sauvegarde
                                updateAnnounce(id_announcement: annonce.id, title: newTitle, description: newDescription) { success, message in
                                    if success {
                                        print("Annonce mise à jour avec succès")
                                    } else {
                                        print("Erreur lors de la mise à jour: \(message ?? "Erreur inconnue")")
                                    }
                                }
                            })
        }
        .sheet(isPresented: $isMessageViewPresented) {
            MessageView(recipientId: annonce.userId,
                        announcementId: annonce.id)
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

//#Preview {
//    AnnonceDetailView()
//}
