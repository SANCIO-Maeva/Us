//
//  CategoriesMethods.swift
//  Us
//
//  Created by Maëva SANCIO on 09/04/2025.
//

import Foundation

// MARK: - Categorie Methods

func getCategories(completion: @escaping (Bool, [Category]?, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/categories") else {
        completion(false, nil, "URL invalide")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(false, nil, "Erreur de réseau: \(error.localizedDescription)")
            return
        }
        guard let data = data else {
            completion(false, nil, "Aucune donnée reçue")
            return
        }

        // Afficher les données JSON reçues pour vérification
        if let jsonString = String(data: data, encoding: .utf8) {
//            print("Données JSON reçues: \(jsonString)")
        }

        let decoder = JSONDecoder()

        do {
            let allCategories = try decoder.decode([Category].self, from: data)
            completion(true, allCategories, nil)
        } catch {
            completion(false, nil, "Erreur de décodage JSON: \(error.localizedDescription)")
        }
    }
    task.resume()
}

