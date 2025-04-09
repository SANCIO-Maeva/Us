//
//  MessagesMethods.swift
//  Us
//
//  Created by Maëva SANCIO on 28/03/2025.
//

import Foundation

// MARK: - Message Methods

func sendMessage(
    id_message: Int,
    content: String,
    userIdSender: Int,
    userIdReceiver: Int,
    announcementId: Int,
    conversationId: Int,
    timestamp: Date,
    completion: @escaping (Bool, String?) -> Void
) {
    guard let url = URL(string: "http://localhost:3000/v1/messages") else {
        DispatchQueue.main.async { completion(false, "URL invalide") }
        return
    }
    
    let message = Msg(
        id_message:id_message,
        content: content,
        userIdSender: userIdSender,
        userIdReceiver: userIdReceiver,
        announcementId: announcementId,
        conversationId: conversationId,
        timestamp: currentDate.ISO8601Format()
    )

    
    guard let httpBody = try? JSONEncoder().encode(message) else {
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
                DispatchQueue.main.async { completion(false, "Erreur lors de la création du message") }
            }
        } catch {
            DispatchQueue.main.async { completion(false, "Erreur de traitement des données: \(error.localizedDescription)") }
        }
    }.resume()
}

func getMessages(userId1: Int, userId2: Int, completion: @escaping (Bool, [Msg]?, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/messages/discussion/\(userId1)/\(userId2)") else {
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
            print("Données JSON reçues: \(jsonString)")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Si le timestamp est en format ISO 8601

        do {
            let messages = try decoder.decode([Msg].self, from: data)
            completion(true, messages, nil)
        } catch let decodingError {
            print("Erreur de décodage JSON : \(decodingError)")
            completion(false, nil, "Erreur de décodage JSON: \(decodingError.localizedDescription)")
        }
    }
    task.resume()
}

