//
//  AuthController.swift
//  Us
//
//  Created by Maëva SANCIO on 28/03/2025.
//

import Foundation

// MARK: - Authentication Methods

// Authenticates the user and saves user data in UserDefaults
func authenticateUser(mail: String, password: String, completion: @escaping (Bool, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/auth/login") else {
        DispatchQueue.main.async { completion(false, "URL invalide") }
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["mail": mail, "password": password])
    
    URLSession.shared.dataTask(with: request) { data, _, error in
        if let error = error {
            DispatchQueue.main.async { completion(false, "Erreur réseau : \(error.localizedDescription)") }
            return
        }
        
        guard let data = data else {
            DispatchQueue.main.async { completion(false, "Aucune donnée reçue") }
            return
        }
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let userDict = jsonResponse?["user"] as? [String: Any] else {
                let errorMessage = jsonResponse?["message"] as? String ?? "Identifiants incorrects"
                DispatchQueue.main.async { completion(false, errorMessage) }
                return
            }
            
            let jsonUser = try JSONSerialization.data(withJSONObject: userDict, options: [])
            UserDefaults.standard.set(jsonUser, forKey: "User")
            
            DispatchQueue.main.async {
                completion(true, nil)  // Envoie aussi l'ID dans la réponse
                //                print("Utilisateur sauvegardé :", userDict)
            }
        } catch {
            DispatchQueue.main.async { completion(false, "Erreur de décodage JSON : \(error.localizedDescription)") }
        }
    }.resume()
}

// Authenticates the user based on forgotten credentials (mail and phone)
func authenticateForgotUser(mail: String, phone: String, completion: @escaping (Bool, String?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/v1/auth/forgot") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["mail": mail, "phone": phone])
    
    URLSession.shared.dataTask(with: request) { data, _, error in
        if let error = error {
            DispatchQueue.main.async { completion(false, "Erreur réseau : \(error.localizedDescription)") }
            return
        }
        
        guard let data = data else {
            DispatchQueue.main.async { completion(false, "Aucune donnée reçue") }
            return
        }
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let userDict = jsonResponse?["user"] as? [String: Any] else {
                let errorMessage = jsonResponse?["message"] as? String ?? "Identifiants incorrects"
                DispatchQueue.main.async { completion(false, errorMessage) }
                return
            }
            
            let jsonUser = try JSONSerialization.data(withJSONObject: userDict, options: [])
            UserDefaults.standard.set(jsonUser, forKey: "User")
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
        } catch {
            DispatchQueue.main.async { completion(false, "Erreur de décodage JSON : \(error.localizedDescription)") }
        }
    }.resume()
}
