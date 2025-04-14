//
//  CategoryView.swift
//  Us
//
//  Created by Maëva SANCIO on 09/04/2025.
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    @State private var announcementCategory: [Announcement] = []
        
    private func isUserAnnonce(_ annonce: Announcement) -> Bool {
        guard let user = UserDefaults.standard.user(forKey: "User") else {
            return false
        }
        return annonce.userId == user.id
    }

    private func fetchAnnouncementsForCategory(categoryId: Int) {
        getAnnounceByCategoryId(categoryId: categoryId) { success, announcements, errorMessage in
            if success, let announcements = announcements {
                self.announcementCategory = announcements
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack (alignment: .leading, spacing: 20) {
                // Titre de la catégorie
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        // Vérifier s'il y a des annonces
                        if announcementCategory.isEmpty {
                            Text("Aucune annonce pour cette catégorie")
                                .foregroundColor(.gray)
                                .italic()
                        } else {
                            ForEach(announcementCategory) { announcement in
                                NavigationLink(destination: AnnonceDetailView(annonce: announcement, isMyAnnonce: isUserAnnonce(announcement))) {
                                    CardView2(title: announcement.title, description: announcement.description)
                                }
                            }
                        }
                    }
                }
            }
            ToolBarView()
        }
        .navigationBarTitle("Catégorie \(category.name)", displayMode: .inline)
        .onAppear {
            fetchAnnouncementsForCategory(categoryId: category.id)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
