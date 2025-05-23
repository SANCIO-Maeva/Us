//
//  HomeView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var fullname: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var announcements: [Announcement] = []
    @State private var allAnnouncements: [Announcement] = []
    @State private var AnnouncementCategory: [Announcement] = []
    
    private func loadUserProfile() {
        if let user = UserDefaults.standard.user(forKey: "User") {
            self.fullname = user.fullname
            self.isAuthenticated = true
            fetchUserAnnouncements(userId: user.id)
            fetchAnnouncements()
        } else {
            print("Aucun utilisateur connecté")
            self.isAuthenticated = false
        }
    }
    
    private func fetchUserAnnouncements(userId: Int) {
        getAnnounceById(userId: userId) { success, announcements, errorMessage in
            if success, let announcements = announcements {
                self.announcements = announcements
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }
    
    private func fetchCategoriesAnnouncements(categoryId: Int) {
        getAnnounceByCategoryId(categoryId: categoryId) { success, AnnouncementCategory, errorMessage in
            if success, let AnnouncementCategory = AnnouncementCategory {
                self.AnnouncementCategory = AnnouncementCategory
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }

    
    private func fetchAnnouncements() {
        getAnnounce { success, allAnnouncements, errorMessage in
            if success, let allAnnouncements = allAnnouncements {
                self.allAnnouncements = allAnnouncements
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }
        
    private func isUserAnnonce(_ annonce: Announcement) -> Bool {
        guard let user = UserDefaults.standard.user(forKey: "User") else {
            return false
        }
        return annonce.userId == user.id
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(fullname: $fullname, allAnnouncements: AnnouncementCategory)

                    if isAuthenticated {
                        HStack {
                            Text("Vos annonces")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Font"))
                            Spacer()
                            NavigationLink(destination: AnnouncementsView()) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(Color("Peach")
                                    )
                            }
                        }
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                if announcements.isEmpty {
                                    Text("Aucune annonce disponible")
                                        .foregroundColor(.gray)
                                        .italic()
                                } else {
                                    ForEach(announcements) { announcement in
                                        NavigationLink(destination: AnnonceDetailView(annonce: announcement, isMyAnnonce: isUserAnnonce(announcement))) {
                                            CardView(title: announcement.title, description: announcement.description, createdAt: announcement.createdAt)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Text("Veuillez vous connecter pour voir vos annonces")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top)
                    }
                    
                    Divider().padding(.vertical, 5)
                    
                    Text("Toutes les annonces")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Font"))

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(allAnnouncements) { announcement in
                                NavigationLink(destination: AnnonceDetailView(annonce: announcement, isMyAnnonce: isUserAnnonce(announcement))) {
                                    CardView2(title: announcement.title, description: announcement.description)
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .padding(.top)
            ToolBarView(selectedTab: "home")
        }
        .onAppear {
            loadUserProfile()
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}
