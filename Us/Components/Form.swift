//
//  Form.swift
//  Us
//
//  Created by Maëva SANCIO on 23/04/2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.8))
            .border(Color.peach)
            .cornerRadius(10)
    }
}

struct TextEditorView: View {
    @Binding var description: String
    var body: some View {        
        TextEditor(text: $description)
            .frame(height: 150)
            .padding()
            .background(Color.white.opacity(0.8))
            .border(Color.peach)

            .cornerRadius(10)
    }
}

struct SecureCustomField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .border(Color.peach)
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
