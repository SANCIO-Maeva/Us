//
//  HomeView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var firstname: String = ""
    @State private var name: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var announcements: [Announcement] = []
    @State private var allAnnouncements: [Announcement] = []
    @State private var AnnouncementCategory: [Announcement] = []
    
    private func loadUserProfile() {
        if let user = UserDefaults.standard.user(forKey: "User") {
            self.firstname = user.firstname ?? ""
            self.name = user.name
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
                    HeaderView(firstname: $firstname, name: $name, allAnnouncements: AnnouncementCategory)

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
                                    .foregroundColor(Color("Peach"))
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
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(allAnnouncements) { announcement in
                            NavigationLink(destination: AnnonceDetailView(annonce: announcement, isMyAnnonce: isUserAnnonce(announcement))) {
                                CardView2(title: announcement.title, description: announcement.description)
                            }
                        }
                    }
                }
            }
            .padding()
            ToolBarView(selectedTab: "home")
        }
        .onAppear {
            loadUserProfile()
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CardView: View {
    let title: String
    let description: String
    let createdAt: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color("Font"))
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.9))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            HStack {
                Text(createdAt)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Font"))
                
                Spacer()
                Text("Voir plus")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(Color("SkyBlue"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        Capsule()
                            .stroke(Color("Peach"), lineWidth: 1.5)
                    )
            }
        }
        .padding()
        .frame(width: 280, height: 160)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("Peach"), lineWidth: 2)
        )
    }
}

struct CardView2: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color("Font"))
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.9))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Voir plus")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(Color("SkyBlue"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        Capsule()
                            .stroke(Color("Peach"), lineWidth: 1.5)
                    )
            }
        }
        .padding()
        .frame(width: 370, height: 160)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("Peach"), lineWidth: 2)
        )
    }
}

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


    @Binding var firstname: String
    @Binding var name: String
    
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
                        Text(firstname)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(name)
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

struct ToolBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var selectedTab: String = ""

    var body: some View {
        HStack {
            ToolBarItem(icon: "house.fill", title: "Accueil", color: Color("SkyBlue"), tag: "home", selectedTab: $selectedTab) {
                HomeView()
            }
            
            Spacer()
            
            ToolBarItem(icon: "plus.circle.fill", title: "Ajouter", color: Color("SkyBlue"), tag: "add", selectedTab: $selectedTab) {
                AnnouncementsView()
            }
            
            Spacer()
            
            ToolBarItem(icon: "message.fill", title: "Messages", color: Color("SkyBlue"), tag: "messages", selectedTab: $selectedTab) {
                DiscussionsView()
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

struct ToolBarItem<Destination: View>: View {
    let icon: String
    let title: String
    let color: Color
    let tag: String
    @Binding var selectedTab: String
    let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()
            .onAppear { selectedTab = tag }) {
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(selectedTab == tag ? color : .gray)
                    
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(selectedTab == tag ? color : .gray)
                }
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
            }
    }
}
