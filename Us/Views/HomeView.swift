//
//  HomeView.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var firstname: String = ""
    @State private var name: String = ""
    @State private var title: String = ""
    @State private var description: String = ""

    @State private var isAuthenticated: Bool = false
    @State private var announcements: [Announcement] = []
    @State private var allAnnouncements: [Announcement] = []
    
    private func loadUserProfile() {
        if let user = UserDefaults.standard.user(forKey: "User") {
            self.firstname = user.firstname ?? ""
            self.name = user.name
            self.isAuthenticated = true
            fetchUserAnnouncements(userId: user.id)
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

    private func fetchAnnouncements() {
        getAnnounce { success, allAnnouncements, errorMessage in
            if success, let allAnnouncements = allAnnouncements {
                    self.allAnnouncements = allAnnouncements
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack{
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(firstname: $firstname, name: $name)
                    
                    if isAuthenticated {
                        HStack {
                            Text("Vos annonces")
                                .font(.title2)
                                .bold()
                            Spacer()
                            NavigationLink(destination: AnnouncementsView()) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
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
                                        NavigationLink(destination: AnnonceDetailView(annonce: announcement, isMyAnnonce: isUserAnnonce(announcement))){
                                            CardView(title: announcement.title)
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
                    
                    Text("Toutes les annonces")
                        .font(.title2)
                        .bold()
                }

                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(allAnnouncements) { announcement in
                                NavigationLink(destination: AnnonceDetailView(annonce: announcement, isMyAnnonce: isUserAnnonce(announcement))) {
                                    CardView2(title: announcement.title)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            ToolBarView()
        }
        .onAppear {
            loadUserProfile()
            fetchAnnouncements()
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func isUserAnnonce(_ annonce: Announcement) -> Bool {
        guard let user = UserDefaults.standard.user(forKey: "User") else {
            return false
        }
        return annonce.userId == user.id
    }
}

#Preview {
    HomeView()
}

struct CardView: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: 280, height: 160)
        .background(Color.blue.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}

struct CardView2: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: 350, height: 160)
        .background(Color.blue.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
}


struct HeaderView: View {
    @Binding var firstname: String
    @Binding var name: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Bienvenue")
                    .font(.title2)
                    .bold()
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
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom)
    }
}

struct ToolBarView: View {
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: HomeView()) {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.title2)
                        Text("Accueil")
                            .font(.footnote)
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
                NavigationLink(destination: AnnouncementsView()) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Ajouter")
                            .font(.footnote)
                    }
                    .foregroundColor(.green)
                }
                Spacer()
                NavigationLink(destination: HomeView()) {
                    VStack {
                        Image(systemName: "message.fill")
                            .font(.title2)
                        Text("Messages")
                            .font(.footnote)
                    }
                    .foregroundColor(.purple)
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}
