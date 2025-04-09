//
//  ForgetPassword.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

struct ForgotPassword: View {
    
    @State var mail: String = ""
    @State var phone: String = ""
    
    @State var authenticationFail: Bool = false
    @State var authenticationSucceed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ForgotText()
                    VerifyMailTextField(mail: $mail)
                    VerifyPhoneTextField(phone: $phone)
                    
                    if authenticationFail{
                        Text("Information incorrecte.")
                            .offset(y:-10)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        Us.authenticateForgotUser(mail: mail, phone: phone) { success, errorMessage in
                            authenticationSucceed = success
                            authenticationFail = !success
                        }
                    }) {
                        VerifyButtonContent()
                    }
                    
                }
                .padding()
                if authenticationSucceed{
                    NavigationView{UpdatePassword()}
                }
            }
        }
    }
    
    struct UpdatePassword: View {
        
        @State var newpassword: String = ""
        @State var confirmedpassword: String = ""
        
        @State var authenticationFail: Bool = false
        @State var authenticationSucceed: Bool = false
        
        
        var body: some View {
            NavigationView {
                ZStack {
                    VStack {
                        ForgotText()
                        NewPassword(newpassword: $newpassword)
                        ConfirmedPassword(confirmedpassword: $confirmedpassword)
                        
                        if authenticationFail{
                            Text("Les mots de passes ne sont pas identiques.")
                                .offset(y:-10)
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            if newpassword == confirmedpassword {
                                self.authenticationSucceed = true
                                self.authenticationFail = false
                            } else {
                                self.authenticationFail = true
                                self.authenticationSucceed = false
                            }
                        }) {
                            ConfirmedButtonContent()
                        }
                    }
                    .padding()
                    if authenticationSucceed{
                        NavigationView{ContentView()}
                    }
                }
            }
        }
    }
    
    
    #Preview {
        UpdatePassword()
    }
    
    //ForgotPassword
    struct ForgotText: View {
        var body: some View {
            Text("Mot de Passe oublié ?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            Text("Vérifiez votre email et votre numéro de téléphone")
                .font(.caption)
                .fontWeight(.light)
                .padding(.bottom, 80)
        }
    }
    
    struct VerifyMailTextField: View {
        
        @Binding var mail: String
        
        var body: some View {
            TextField(("Email"), text: $mail)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                .padding(.horizontal, 20)
        }
    }
    
    struct VerifyPhoneTextField: View {
        
        @Binding var phone: String
        
        var body: some View {
            TextField(("Téléphone"), text: $phone)
                .keyboardType(.phonePad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                .padding(.horizontal, 20)
                .padding(.bottom,30)
        }
    }
    
    struct VerifyButtonContent: View {
        var body: some View {
            Text("Vérifier")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 350, height: 60)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
        }
    }
    
    
    //UpdatePassword
    struct ConfirmedButtonContent: View {
        var body: some View {
            Text("Valider")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 350, height: 60)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
        }
    }
    
    struct NewPassword: View {
        
        @Binding var newpassword: String
        
        var body: some View {
            SecureField(("Nouveau mot de passe"), text: $newpassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                .padding(.horizontal, 20)
        }
    }
    
    struct ConfirmedPassword: View {
        
        @Binding var confirmedpassword: String
        
        var body: some View {
            SecureField(("Confirmer le mot de passe"), text: $confirmedpassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                .padding(.horizontal, 20)
                .padding(.bottom,30)
            
        }
    }
}
