//
//  Models.swift
//  Us
//
//  Created by Maëva SANCIO on 28/03/2025.
//
// MARK: - Models

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let firstname: String?
    let mail: String
    let password: String?
    let role: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let postal_code: String?
    let bio: String?
    let phone: String?
}

struct Category: Codable, Identifiable {
    var id: Int
    var id_category: Int
    var name: String
}

struct Announcement: Codable, Identifiable {
    var id: Int
    var id_announcement: Int
    var title: String
    var description: String
    var image: String?
    var userId: Int
    var createdAt: String
    var updatedAt: String
    var categoryId: Int
}

struct Msg: Codable, Identifiable {
    var id: Int { id_message }
    var id_message: Int
    var content: String
    var userIdSender: Int
    var userIdReceiver: Int
    var announcementId: Int?
    var conversationId: Int
    var timestamp: String
//    var isRead: Bool
}

struct Conversation: Codable, Identifiable {
    var id: Int { id_conversation }
    var id_conversation: Int
    var userSender: Int
    var userReceiver: Int
    var user1: BasicUser
    var user2: BasicUser
    var lastMessageId: Int
    var lastMessage: BasicMessage
    var updatedAt: String
    var announcementId: Int

    struct BasicUser: Codable {
        var id_user: Int
        var firstname: String
        var name: String
    }
    struct BasicMessage: Codable {
        var id_message: Int
        var content: String
//        var isRead: Bool
    }

//    // Pour afficher le bon nom en fonction de l'utilisateur actuel
    func displayName(for currentUserId: Int) -> String {
        return currentUserId == userSender
            ? "\(user2.firstname) \(user2.name)"
            : "\(user1.firstname) \(user1.name)"
    }
}
