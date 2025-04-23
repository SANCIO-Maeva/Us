//
//  DiscussionsView.swift
//  Us
//
//  Created by Maëva SANCIO on 10/03/2025.
//

import SwiftUI

struct DiscussionsView: View {
    @State private var allConversations: [Conversation] = []
    @State private var userId: Int = 0
    @State private var refreshTimer: Timer?
    @State private var hasNewMessages: Bool = false

    
    private func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            fetchConversations(userId: userId)
        }
    }

    private func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    private func loadUserProfile() {
        if let user = UserDefaults.standard.user(forKey: "User") {
            self.userId = user.id
            fetchConversations(userId: user.id)
        } else {
            print("Aucun utilisateur connecté")
        }
    }
    
    private func fetchConversations(userId: Int) {
        getConversation(userId: userId) { success, allConversations, errorMessage in
            if success, let allConversations = allConversations {
                self.allConversations = allConversations
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Messagerie")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .foregroundColor(Color("Font"))
                    
                    ForEach(allConversations) { conversation in
                        NavigationLink(destination: ChatView(userId: userId, conversation: conversation)) {
                            ConversationRow(conversation: conversation)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
            ToolBarView(selectedTab: "messages")
        }
        .onAppear {
            loadUserProfile()
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.mint)
                .frame(width: 50, height: 50)
                .overlay(Text(conversation.user1.fullname.prefix(1)).foregroundColor(.white))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.user1.fullname)
                    .font(.headline)
                Text(conversation.lastMessage.content.prefix(20))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(conversation.updatedAt)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding(10)
    }
}

struct ChatView: View {
    let userId: Int
    let conversation: Conversation
    @State private var messages: [Msg] = []
    @State private var refreshTimer: Timer?

    func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            fetchMessages()
        }
    }

    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func fetchMessages() {
        getMessages(userId1: userId, userId2: conversation.user1.id_user) { success, allMessages, errorMessage in
            if success, let allMessages = allMessages {
                self.messages = allMessages
            } else {
                print(errorMessage ?? "Erreur inconnue")
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        MessageBubble(message: message, isSent: message.userIdSender == userId)
                    }
                }
                .padding()
            }
            
            Divider()
            
            MessageInputView(
                userIdSender: userId,
                recipientId: conversation.user1.id_user,
                announcementId: conversation.announcementId,
                conversationId: conversation.id_conversation,
                onSend: {
                    fetchMessages()  // Refresh après envoi
                }
            )
                .padding()
                .background(Color(.systemGray6))
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .navigationTitle(conversation.user1.fullname)
        .onAppear {
            fetchMessages()
            startAutoRefresh()
        }
        .onDisappear {
            stopAutoRefresh()
        }
    }
}

struct MessageBubble: View {
    let message: Msg
    let isSent: Bool
    
    var body: some View {
        HStack {
            if isSent { Spacer() }
            
            Text(message.content)
                .padding()
                .background(isSent ? Color(red: 0.6, green: 0.8, blue: 1.0) : Color(red: 0.95, green: 0.95, blue: 0.95))
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: 250, alignment: isSent ? .trailing : .leading)
            
            if !isSent { Spacer() }
        }
        .padding(.horizontal)
    }
}

struct MessageInputView: View {
    @State private var messageText = ""
    let userIdSender: Int
    let recipientId: Int
    let announcementId: Int
    let conversationId: Int

    var onSend: () -> Void  // ➕ nouveau paramètre

    var body: some View {
        HStack(spacing: 10) {
            TextField("Écrire un message...", text: $messageText)
                .padding(12)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)

            Button(action: {
                guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

                sendMessage(
                    id_message: Int(),
                    content: messageText,
                    userIdSender: userIdSender,
                    userIdReceiver: recipientId,
                    announcementId: announcementId,
                    conversationId: conversationId,
                    timestamp: Date()
                ) { success, error in
                    if success {
                        messageText = ""
                        onSend()  // ➕ refresh les messages
                    } else {
                        print("Erreur: \(error ?? "Erreur inconnue")")
                    }
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.mint)
                    .clipShape(Circle())
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}
