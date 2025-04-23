//
//  Cards.swift
//  Us
//
//  Created by Maëva SANCIO on 23/04/2025.
//

import SwiftUI

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
