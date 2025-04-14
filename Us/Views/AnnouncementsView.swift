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
    @State private var showConfirmation: Bool = false
    
    @State private var selectedCategory: Int = 1
    @State private var categories: [Category] = []
    
    private func fetchUserId() {
        if let userData = UserDefaults.standard.user(forKey: "User") {
            self.userId = userData.id
        }
    }
    
    private func fetchCategories() {
        getCategories { success, allCategories, errorMessage in
            if success, let allCategories = allCategories {
                self.categories = allCategories
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }
    
    func convertUIImageToBase64(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return nil }
        return imageData.base64EncodedString()
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Spacer()
                        Text("Créer une annonce")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .foregroundColor(Color("Font"))
                        
                        AnnonceTitleView(title: $title)
                        // Picker pour sélectionner une catégorie
                        VStack {
                            Text("Sélectionner une catégorie")
                                .font(.headline)
                            
                            Picker("Catégorie", selection: $selectedCategory) {
                                ForEach(categories, id: \.id) { category in
                                    Text(category.name).tag(category.id)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal,20)
                            .padding(.vertical,10)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                        }
                        TextEditorView(description: $description)
                        PhotoSelectionView(selectedPhotos: $selectedPhotos, selectedImages: $selectedImages)
                        
                    }
                    .padding()
                }
                
                VStack {
                    Button(action: {
                        showConfirmation = true
                    }) {
                        SubmitButtonContent()
                    }
                    .alert(isPresented: $showConfirmation) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Voulez-vous vraiment publier cette annonce ?"),
                            primaryButton: .default(Text("Oui")) {
                                let currentDate = Date()
                                
                                // Convertir la première image sélectionnée en base64
                                if let firstImage = selectedImages.first,
                                   let base64String = convertUIImageToBase64(image: firstImage) {
                                    image = base64String
                                } else {
                                    image = ""
                                }
                                
                                createAnnouncement(
                                    id_announcement: Int(),
                                    title: title,
                                    description: description,
                                    image: image,
                                    userId: userId,
                                    createdAt: currentDate,
                                    updatedAt: currentDate,
                                    categoryId: selectedCategory
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
                    
                    ToolBarView(selectedTab:"add")
                }
                .background(Color(.systemGray6).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                fetchUserId()
                fetchCategories()
            }
            
            if authenticationSucceed {
                NavigationView { HomeView() }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SubmitButtonContent: View {
    var body: some View {
        Text("Publier l'annonce")
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("Peach"), Color("SkyBlue")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal)
    }
}

struct AnnonceTitleView: View {
    @Binding var title: String
    var body: some View {
        TextField("Titre de l'annonce", text: $title)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
    }
}

struct TextEditorView: View {
    @Binding var description: String
    var body: some View {
        Text("Ajouter une annonce:")
            .font(.headline)
            .padding(.top)
        
        TextEditor(text: $description)
            .frame(height: 150)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
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
                .padding()
                .background(Color("SkyBlue").opacity(0.2))
                .cornerRadius(10)
            }
            
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
