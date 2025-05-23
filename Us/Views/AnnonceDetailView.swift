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
    @State private var imageData: UIImage? = nil

    @State private var newTitle = ""
    @State private var newDescription = ""

    @State private var updatedTitle: String
    @State private var updatedDescription: String
    
    @Environment(\.dismiss) var dismiss

    init(annonce: Announcement, isMyAnnonce: Bool) {
        self.annonce = annonce
        self.isMyAnnonce = isMyAnnonce
        _updatedTitle = State(initialValue: annonce.title)
        _updatedDescription = State(initialValue: annonce.description)
        if let imageString = annonce.image,
           let imageDataDecoded = Data(base64Encoded: imageString),
           let uiImage = UIImage(data: imageDataDecoded) {
            _imageData = State(initialValue: uiImage)
        }
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Titre de l'annonce")
                        .font(.headline)
                        .foregroundColor(Color("Font"))

                    Text(updatedTitle)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("Peach"))

                    Divider()

                    Text("Description")
                        .font(.headline)
                        .foregroundColor(Color("Font"))

                    Text(updatedDescription)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Text("Photos")
                        .font(.headline)
                        .foregroundColor(Color("Font"))
                    if let image = imageData {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .padding()
                    } else {
                        Text("Aucune image disponible.")
                            .foregroundColor(.gray)
                    }

                }
                .padding()
            }

            VStack(spacing: 12) {
                if isMyAnnonce {
                    Button(action: {
                        newTitle = updatedTitle
                        newDescription = updatedDescription
                        isEditing2.toggle()
                    }) {
                        ButtonContent(title: "Modifier l'annonce")
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
                    Button(action: {
                        isMessageViewPresented.toggle()
                    }) {
                        ButtonContent(title: "Envoyer un message")
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGray6).opacity(0.2))
        .navigationTitle("Détail de l'annonce")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Êtes-vous sûr de vouloir supprimer cette annonce ?", isPresented: $showAlert) {
            Button("Annuler", role: .cancel) {}
            Button("Supprimer", role: .destructive) {
                deleteAnnounce(id_announcement: annonce.id) { success, message in
                    if success {
                        DispatchQueue.main.async {
                            dismiss() // Ferme la vue actuelle
                        }
                    } else {
                        print("Erreur : \(message ?? "Erreur inconnue")")
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing2) {
            EditAnnonceView(
                title: $newTitle,
                description: $newDescription,
                onSave: {
                    updateAnnounce(id_announcement: annonce.id, title: newTitle, description: newDescription) { success, message in
                        if success {
                            updatedTitle = newTitle
                            updatedDescription = newDescription
                        } else {
                            print("Erreur : \(message ?? "Erreur inconnue")")
                        }
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
    @Environment(\.presentationMode) var presentationMode

    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titre de l'annonce")) {
                    CustomTextField(placeholder: "Titre de l'annonce", text: $title)
                }
                Section(header: Text("Description")) {
                    TextEditorView(description: $description)
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
                
                TextEditorView(description: $message)
                
                Spacer()
                
                Button(action: {
                    sendMessage(
                        id_message: Int.init(),
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
                    ButtonContent(title: "Envoyer")
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


