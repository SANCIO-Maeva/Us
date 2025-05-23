//
//  ConversationsMethodes.swift
//  Us
//
//  Created by Maëva SANCIO on 28/03/2025.
//

import Foundation

func getConversation(userId: Int, completion: @escaping (Bool, [Conversation]?, String?) -> Void) {
    let apiBaseUrl = Bundle.main.object(forInfoDictionaryKey: "ApiBaseUrl") as! String

    guard let url = URL(string: apiBaseUrl + "/conversations/user/\(userId)") else {
        completion(false, nil, "URL invalide")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        do{
            if let error = error {
                completion(false, nil, "Erreur de réseau: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                completion(false, nil, "Aucune donnée reçue")
                return
            }
            
            // Afficher les données JSON reçues pour vérification
            if let jsonString = String(data:data, encoding: .utf8) {
                print("Données JSON reçues: \(jsonString)")
            }
            print (data)
            let decoder = JSONDecoder()
            let allConversations = try decoder.decode([Conversation].self, from: data)
            completion(true, allConversations, nil)
            
        } catch let decodingError {
            print("Erreur de décodage JSON : \(decodingError)")
            completion(false, nil, "Erreur de décodage JSON: \(decodingError.localizedDescription)")
        }
    }
    task.resume()
}
