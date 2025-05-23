//
//  Button.swift
//  Us
//
//  Created by Maëva SANCIO on 28/04/2025.
//

import SwiftUICore
import SwiftUI

struct ButtonContent: View {
    var title: String

    var body: some View {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.peach)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
    }
}
