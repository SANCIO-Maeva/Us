//
//  ApiClient.swift
//  Us
//
//  Created by Maëva SANCIO on 10/03/2025.
//

import Foundation

let currentDate = Date()


// MARK: - UserDefaults Extension for Storing User Data

extension UserDefaults {
    func user(forKey defaultName: String) -> User? {
        guard let data = data(forKey: defaultName) else { return nil }
        do {
            return try JSONDecoder().decode(User.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func set(_ value: User, forKey defaultName: String) {
        if let data = try? JSONEncoder().encode(value) {
            set(data, forKey: defaultName)
        }
    }
}
