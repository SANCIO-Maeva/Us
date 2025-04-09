//
//  UsersController.swift
//  Us
//
//  Created by Maëva SANCIO on 28/03/2025.
//

import Foundation
import SwiftUI

// MARK: - User Actions

func updatePassword(id: Int, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
    // Remplacer par l'URL de votre serveur réel
    guard let url = URL(string: "http://localhost:3000/v1/users/\(id)") else {
        completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])))
        return
    }

    // Créer un dictionnaire avec uniquement le mot de passe à mettre à jour
    let parameters: [String: Any] = ["password": newPassword]

    // Convertir les paramètres en JSON
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"  // Méthode PUT pour mettre à jour
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData  // Ajouter les données dans le corps de la requête

        // Utiliser URLSession pour envoyer la requête asynchrone
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Si une erreur se produit lors de la requête
                completion(.failure(error))
                return
            }

            // Vérifier que le serveur a retourné une réponse valide
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Succès
                completion(.success(()))
            } else {
                // Si le serveur retourne un code d'état différent de 200 (succès)
                let errorMessage = "Erreur lors de la mise à jour du mot de passe."
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()  // Démarrer la tâche réseau

    } catch {
        // Si l'encodage JSON échoue
        completion(.failure(error))
    }
}


// Logs out the current user by clearing stored data
func logout() {
    print("Déconnexion...")
    
    UserDefaults.standard.removeObject(forKey: "User")
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
        window.rootViewController = UIHostingController(rootView: ContentView())
        window.makeKeyAndVisible()
    }
}

// MARK: - User Creation

// Fetches coordinates from OpenStreetMap API based on an address
func fetchCoordinates(for address: String, completion: @escaping (Double?, Double?, String?) -> Void) {
    let urlString = "https://nominatim.openstreetmap.org/search?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&format=json&limit=1"
    
    guard let url = URL(string: urlString) else {
        completion(nil, nil, "URL invalide.")
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            completion(nil, nil, "Erreur réseau: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            completion(nil, nil, "Aucune donnée reçue.")
            return
        }
        
        do {
            if let results = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
               let firstResult = results.first,
               let latString = firstResult["lat"] as? String,
               let lonString = firstResult["lon"] as? String {
                
                if let lat = Double(latString), let lon = Double(lonString) {
                    completion(lat, lon, nil)
                } else {
                    completion(nil, nil, "Les coordonnées sont invalides.")
                }
            } else {
                completion(nil, nil, "Aucune adresse trouvée.")
            }
        } catch {
            completion(nil, nil, "Erreur de parsing JSON: \(error.localizedDescription)")
        }
    }.resume()
}

// Creates a new user on the server
func createUser(
    id_user: Int,
    name: String,
    firstname: String,
    address: String,
    phone: String,
    mail: String,
    password: String,
    postal_code: String,
    bio: String,
    latitude: String,
    longitude: String,
    completion: @escaping (Bool, String?) -> Void
) {
    guard let latitudeDouble = Double(latitude), let longitudeDouble = Double(longitude) else {
        DispatchQueue.main.async { completion(false, "Les coordonnées sont invalides.") }
        return
    }
    
    guard let url = URL(string: "http://localhost:3000/v1/users") else {
        DispatchQueue.main.async { completion(false, "URL invalide") }
        return
    }
    
    let user = User(
        id: id_user,
        name: name,
        firstname: firstname,
        mail: mail,
        password: password,
        role: "Admin",
        address: address,
        latitude: latitudeDouble,
        longitude: longitudeDouble,
        postal_code: postal_code,
        bio: bio,
        phone: phone
    )
    
    guard let httpBody = try? JSONEncoder().encode(user) else {
        DispatchQueue.main.async { completion(false, "Erreur de sérialisation JSON") }
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = httpBody
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            DispatchQueue.main.async { completion(false, "Erreur de connexion: \(error.localizedDescription)") }
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            DispatchQueue.main.async { completion(false, "Réponse du serveur invalide.") }
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async { completion(false, "Erreur serveur: Code \(httpResponse.statusCode) - \(responseText)") }
            } else {
                DispatchQueue.main.async { completion(false, "Erreur serveur: Code \(httpResponse.statusCode)") }
            }
            return
        }
        
        
        guard let data = data else {
            DispatchQueue.main.async { completion(false, "Aucune réponse du serveur") }
            return
        }
        
        do {
            //            print(data)
            let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            //            print(responseDict)
            if let userDict = responseDict?["user"] as? [String: Any] {
                let jsonUser = try? JSONSerialization.data(withJSONObject: userDict, options: [])
                UserDefaults.standard.set(jsonUser, forKey: "User")
                DispatchQueue.main.async { completion(true, nil)
                }
            } else {
                let errorMessage = (responseDict?["error"] as? String) ?? "Erreur lors de la création de l'utilisateur"
                DispatchQueue.main.async { completion(false, errorMessage) }
            }
        } catch {
            DispatchQueue.main.async { completion(false, "Erreur de traitement des données: \(error.localizedDescription)") }
        }
    }.resume()
}
