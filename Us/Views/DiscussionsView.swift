//
//  DiscussionsView.swift
//  Us
//
//  Created by Maëva SANCIO on 10/03/2025.
//

import SwiftUI


struct DiscussionsView: View {
    let conversations: [Conversation] = [
        Conversation(name: "Alice", lastMessage: "Salut, comment ça va ?", time: "12:30"),
        Conversation(name: "Bob", lastMessage: "On se voit demain ?", time: "11:45"),
        Conversation(name: "Charlie", lastMessage: "Merci pour hier !", time: "10:15")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List(conversations) { conversation in
                    NavigationLink(destination: ChatView(conversation: conversation)) {
                        ConversationRow(conversation: conversation)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Messagerie")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ToolBarView()
                }
            }
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .overlay(Text(conversation.name.prefix(1)).foregroundColor(.white))
            
            VStack(alignment: .leading) {
                Text(conversation.name)
                    .font(.headline)
                Text(conversation.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(conversation.time)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(8)
    }
}

struct ChatView: View {
    let conversation: Conversation
    let messages: [Message] = [
        Message(sender: "Alice", text: "Salut, comment ça va ?", isCurrentUser: false),
        Message(sender: "Moi", text: "Ça va bien et toi ?", isCurrentUser: true),
        Message(sender: "Alice", text: "Super, merci !", isCurrentUser: false)
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            MessageInputView()
                .padding()
        }
        .navigationTitle(conversation.name)
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer() }
            
            Text(message.text)
                .padding()
                .background(message.isCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(message.isCurrentUser ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
            if !message.isCurrentUser { Spacer() }
        }
    }
}

struct MessageInputView: View {
    @State private var messageText = ""
    
    var body: some View {
        HStack {
            TextField("Écrire un message...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
            
            Button(action: {
                // Action pour envoyer le message
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 3)
    }
}

#Preview {
    DiscussionsView()
}
