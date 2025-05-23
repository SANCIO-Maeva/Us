//
//  CategoriesMethods.swift
//  Us
//
//  Created by Maëva SANCIO on 09/04/2025.
//

import Foundation

// MARK: - UserDefaults Extension for Storing Categories Data

extension UserDefaults {
    func category(forKey defaultName: String) -> Category? {
        guard let data = data(forKey: defaultName) else { return nil }
        do {
            return try JSONDecoder().decode(Category.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    func set2(_ value: Category, forKey defaultName: String) {
        if let data = try? JSONEncoder().encode(value) {
            set(data, forKey: defaultName)
        }
    }
}
// MARK: - Categorie Methods

func getCategories(completion: @escaping (Bool, [Category]?, String?) -> Void) {
    let apiBaseUrl = Bundle.main.object(forInfoDictionaryKey: "ApiBaseUrl") as! String

    guard let url = URL(string: apiBaseUrl + "/categories") else {
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
        if String(data: data, encoding: .utf8) != nil {
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

