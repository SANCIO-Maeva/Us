//
//  AnnoucementsView.swift
//  Us
//
//  Created by Maëva SANCIO on 05/03/2025.
//

import SwiftUI
import PhotosUI

struct AnnoucementsView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isPaid: Bool = false
    @State private var amount: String = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Créer une annonce")
                        .font(.title2)
                        .bold()
                        .padding()
                    
                    AnnonceTitleView(title: $title)
                    TextEditorView(description:$description)

                    Toggle("Rémunération ?", isOn: $isPaid)
                        .padding()
                    
                    if isPaid {
                        TextField("Montant en €", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                    }

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
                .padding()
            }

            VStack {
                Button(action: submitAd) {
                    SubmitButtonContent()
                }
                .disabled(isSubmitting)
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                ToolBarView()
            }
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func submitAd() {
        guard !title.isEmpty, !description.isEmpty else {
            alertMessage = "Veuillez remplir tous les champs."
            showAlert = true
            return
        }

        isSubmitting = true
        let url = URL(string: "http://localhost:3000/v1/announcements")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "title": title,
            "description": description,
            "isPaid": isPaid,
            "userId": 1
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            alertMessage = "Erreur de formatage des données."
            showAlert = true
            isSubmitting = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Erreur de connexion: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    alertMessage = "Annonce publiée avec succès !"
                } else {
                    alertMessage = "Erreur lors de la publication."
                }
                showAlert = true
            }
        }.resume()
    }
}

#Preview {
    AnnoucementsView()
}

struct SubmitButtonContent: View {
    var body: some View {
        Text("Publier l'annonce")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct AnnonceTitleView: View {
    @Binding var title: String
    var body: some View {
        TextField("Titre de l'annonce", text: $title)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5.0)
    }
}

struct TextEditorView: View {
    @Binding var description: String
    var body: some View {
        TextEditor(text: $description)
            .frame(height: 150)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5.0)
    }
}
