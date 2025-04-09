//
//  AnnoucementsView.swift
//  Us
//
//  Created by Maëva SANCIO on 05/03/2025.
//

import SwiftUI
import PhotosUI

struct AnnouncementsView: View {
    
    @State private var title: String = "Titre 1"
    @State private var description: String = "ceci est un petit test de description"
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var userId: Int = 0
    @State private var image: String = ""
    @State private var authenticationFail: Bool = false
    @State private var authenticationSucceed: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showConfirmation: Bool = false  // Ajout pour afficher la popup
    
    private func fetchUserId() {
        if let userData = UserDefaults.standard.user(forKey: "User") {
            self.userId = userData.id
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Créer une annonce")
                            .font(.title)
                            .bold()
                            .padding(.horizontal)
                        
                        AnnonceTitleView(title: $title)
                        TextEditorView(description: $description)
                        PhotoSelectionView(selectedPhotos: $selectedPhotos, selectedImages: $selectedImages)
                    }
                    .padding()
                }
                
                VStack {
                    Button(action: {
                        showConfirmation = true  // Afficher la popup avant de publier
                    }) {
                        SubmitButtonContent()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .alert(isPresented: $showConfirmation) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Voulez-vous vraiment publier cette annonce ?"),
                            primaryButton: .default(Text("Oui")) {
                                let currentDate = Date()
                                createAnnouncement(
                                    id_announcement: Int.init(),
                                    title: title,
                                    description: description,
                                    image: image,
                                    userId: userId,
                                    createdAt: currentDate,
                                    updatedAt: currentDate
                                ) { success, errorMessage in
                                    DispatchQueue.main.async {
                                        authenticationSucceed = success
                                        authenticationFail = !success
                                        self.errorMessage = errorMessage
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    if authenticationFail {
                        Text(errorMessage ?? "Erreur inconnue.")
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                    }
                    
                    ToolBarView()
                }
                .background(Color(.systemGray6))
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                fetchUserId()
            }
            
            if authenticationSucceed {
                NavigationView { HomeView() }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AnnouncementsView()
}
struct SubmitButtonContent: View {
    var body: some View {
        Text("Publier l'annonce")
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}

struct AnnonceTitleView: View {
    @Binding var title: String
    var body: some View {
        TextField("Titre de l'annonce", text: $title)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

struct TextEditorView: View {
    @Binding var description: String
    var body: some View {
        Text("Ajouter une annonce:")
            .padding(.top)
        
        TextEditor(text: $description)
            .frame(height: 150)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

struct PhotoSelectionView: View {
    @Binding var selectedPhotos: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5, matching: .images) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("Ajouter des photos (\(selectedImages.count)/5)")
                }
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .onChange(of: selectedPhotos) { newItems in
            selectedImages = []
            for item in newItems {
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImages.append(image)
                    }
                }
            }
        }
    }
}
