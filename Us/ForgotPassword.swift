//
//  ForgetPassword.swift
//  Us
//
//  Created by Maëva SANCIO on 27/02/2025.
//

import SwiftUI

let storedVerifyMail = "azerty@azerty.fr"
let storedVerifyPhone = "0612345678"

struct ForgotPassword: View {
    
    @State var verifymail: String = ""
    @State var verifyphone: String = ""
    
    @State var authenticationFail: Bool = false
    @State var authenticationSucceed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ForgotText()
                    VerifyMailTextField(verifymail: $verifymail)
                    VerifyPhoneTextField(verifyphone: $verifyphone)
                                                
                    if authenticationFail{
                        Text("Information incorrecte.")
                            .offset(y:-10)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        if self.verifymail == storedVerifyMail && self.verifyphone == storedVerifyPhone {
                            self.authenticationSucceed = true
                            self.authenticationFail = false
                        } else {
                            self.authenticationFail = true
                            self.authenticationSucceed = false
                        }
                    }) {
                        VerifyButtonContent()
                    }
                }
                .padding()
                }
            }
        }
    }

#Preview {
    ForgotPassword()
}

struct ForgotText: View {
    var body: some View {
        Text("Mot de Passe oublié ?")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
        Text("Vérifiez votre email et votre numéro de téléphone")
            .font(.caption)
            .fontWeight(.light)
            .padding(.bottom, 80)
    }
}

struct VerifyButtonContent: View {
    var body: some View {
        Text("Vérifier")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 250, height: 60)
            .background(Color.black)
            .cornerRadius(35.0)
            .padding(.vertical,20)
    }
}

struct VerifyMailTextField: View {
    
    @Binding var verifymail: String
    
    var body: some View {
        TextField(("Email"), text: $verifymail)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct VerifyPhoneTextField: View {
    
    @Binding var verifyphone: String
    
    var body: some View {
        TextField(("Téléphone"), text: $verifyphone)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
