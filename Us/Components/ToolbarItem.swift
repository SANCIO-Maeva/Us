//
//  ToolBarItem.swift
//  Us
//
//  Created by Maëva SANCIO on 23/04/2025.
//

import SwiftUICore
import SwiftUI

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
