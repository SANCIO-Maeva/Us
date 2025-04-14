//
//  AnnouncementsController.swift
//  Us
//
//  Created by Maëva SANCIO on 28/03/2025.
//

import Foundation

// MARK: - Announcement Methods

func createAnnouncement(
    id_announcement: Int,
    title: String,
    description: String,
    image: String,
    userId: Int,
    createdAt: Date,
    updatedAt: Date,
    categoryId: Int,
    completion: @escaping (Bool, String?) -> Void
) {
    guard let url = URL(string: "http://localhost:3000/v1/announcements") else {
        DispatchQueue.main.async { completion(false, "URL invalide") }
        return
    }
    
    let announcement = Announcement(
            id: id_announcement,
            id_announcement: id_announcement,
            title: title,
            description: description,
            image: image,
            userId: userId,
            createdAt: currentDate.ISO8601Format(),
            updatedAt: currentDate.ISO8601Format(),
            categoryId: categoryId,
        )
    
    guard let httpBody = try? JSONEncoder().encode(announcement) else {
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
            if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async { completion(true, nil)
                }
                print(responseDict)
            } else {
                DispatchQueue.main.async { completion(false, "Erreur lors de la création de l'annonce") }
            }
        } catch {
            DispatchQueue.main.async { completion(false, "Erreur de traitement des données: \(error.localizedDescription)") }
        }
    }.resume()
}

func getAnnounceById(userId: Int, completion: @escaping (Bool, [Announcement]?, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/announcements/user/\(userId)") else {
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
            let announcements = try decoder.decode([Announcement].self, from: data)
            completion(true, announcements, nil)
        } catch {
            completion(false, nil, "Erreur de décodage JSON: \(error.localizedDescription)")
        }
    }
    task.resume()
}

func getAnnounceByCategoryId(categoryId: Int, completion: @escaping (Bool, [Announcement]?, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/announcements/category/\(categoryId)") else {
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
            let AnnouncementCategory = try decoder.decode([Announcement].self, from: data)
            completion(true, AnnouncementCategory, nil)
        } catch {
            completion(false, nil, "Erreur de décodage JSON: \(error.localizedDescription)")
        }
    }
    task.resume()
}


func getAnnounce(completion: @escaping (Bool, [Announcement]?, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/announcements/") else {
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
            let allAnnouncements = try decoder.decode([Announcement].self, from: data)
            completion(true, allAnnouncements, nil)
        } catch {
            completion(false, nil, "Erreur de décodage JSON: \(error.localizedDescription)")
        }
    }
    task.resume()
}

func deleteAnnounce(id_announcement: Int, completion: @escaping (Bool, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/announcements/\(id_announcement)") else {
        completion(false, "URL invalide")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(false, "Erreur de réseau: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if (200...299).contains(httpResponse.statusCode) {
                completion(true, nil)
            } else {
                completion(false, "Échec avec le code \(httpResponse.statusCode)")
            }
        } else {
            completion(false, "Réponse invalide")
        }
    }
    
    task.resume()
}

func updateAnnounce(id_announcement: Int, title: String?, description: String?, completion: @escaping (Bool, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/announcements/\(id_announcement)") else {
        completion(false, "URL invalide")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Créer le dictionnaire des données à envoyer
    var parameters: [String: Any] = [:]
    if let title = title {
        parameters["title"] = title
    }
    if let description = description {
        parameters["description"] = description
    }
    
    // Convertir le dictionnaire en données JSON
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
    } catch {
        completion(false, "Erreur lors de la conversion des données en JSON")
        return
    }
    
    // Effectuer la requête HTTP
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(false, "Erreur réseau: \(error.localizedDescription)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(false, "Réponse invalide du serveur")
            return
        }
        
        if httpResponse.statusCode == 200 {
            completion(true, nil)
        } else {
            completion(false, "Erreur serveur: \(httpResponse.statusCode)")
        }
    }
    
    task.resume()
}
