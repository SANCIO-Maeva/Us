//
//  Header.swift
//  Us
//
//  Created by Maëva SANCIO on 23/04/2025.
//

import SwiftUI

struct ButtonNav: View {
    let name: String
    
    var body: some View {
        HStack() {
            Text(name)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(Color("SkyBlue"))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .overlay(
                    Capsule()
                        .stroke(Color("Peach"), lineWidth: 1.5)
                )
        }
    }
}

struct HeaderView: View {
    @State private var allCategories: [Category] = []
    @State private var AnnouncementCategory: [Announcement] = []


    @Binding var fullname: String
    
    let allAnnouncements: [Announcement]
    
    private func fetchCategories() {
        getCategories { success, allCategories, errorMessage in
            if success, let allCategories = allCategories {
                self.allCategories = allCategories
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Bienvenue")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("Font"))
                    HStack {
                        Text(fullname)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(allCategories) { category in
                        NavigationLink(destination: CategoryView(category: category)) {
                            ButtonNav(name: category.name)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchCategories()
        }
    }
}

