//
//  LoginView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 07/11/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var errorMessage = ""
    @State private var scaleEffect: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        VStack{
            Spacer()
            
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                .resizable()
                .foregroundColor(.white.opacity(0.9))
                .frame(width: 120, height: 105)
                .opacity(opacity)
                .scaleEffect(scaleEffect)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0)) {
                            scaleEffect = 1.0
                            opacity = 0.9
                        }
                    }
                }
                .padding(.top, 60)
                
            Text("Faça login para ter acesso aos recursos do app do Apple Developer Academy do Centro Universitário SENAC")
                .fontWeight(.semibold)
                .foregroundColor(.white).opacity(0.7)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
            
            SignButtonView(errorMessage: $errorMessage)
        }
        .background(Color.bg950)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SignButtonView : View {
    @AppStorage("appleID") var appleID: String?
    @AppStorage("email") var email: String?
    @AppStorage("name") var name: String?
    @AppStorage("studentId") var studentId: String?
    
    @Binding var errorMessage: String
    private let webService = WebService()
    
    @State private var isAuthenticating: Bool = false
    
    var body: some View {
        
        VStack{
            if isAuthenticating {
                ProgressView("Conectando ao banco...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .gradientEnd))
                    .frame(height: 50)
                    .padding()
            }
            else {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                isAuthenticating = true
                                
                                let userId = credential.user
                                let email = credential.email ?? ""
                                var name: String = ""
                                
                                let firstName = credential.fullName?.givenName
                                let middleName = credential.fullName?.middleName
                                let lastName = credential.fullName?.familyName
                                
                                if let middleNameExists = middleName {
                                    name = "\(firstName ?? "") \(middleNameExists) \(lastName ?? "")"
                                } else {
                                    name = "\(firstName ?? "") \(lastName ?? "")"
                                }
                                
                                self.appleID = userId
                                if !name.isEmpty { self.name = name }
                                if !email.isEmpty { self.email = email }
                                
                                registerOrFetchStudent(
                                    name: self.name ?? "Aluno sem nome",
                                    email: self.email ?? "Aluno sem email",
                                    appleId: userId
                                )
    //
    //                            print("User ID: \(userId)")
    //                            print("Email: \(email)")
    //                            print("Name: \(name)")
                                
                            default:
                                break
                            }
                            
                            
                        case .failure(let error):
                    if (error as NSError).code != ASAuthorizationError.canceled.rawValue {
                            errorMessage = "Erro ao realizar o login. Tente novamente. \(error.localizedDescription)"
                        }
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 50)
                .padding()
            }
            
        }
    }
    
    func registerOrFetchStudent(name: String, email: String, appleId: String){
        webService.authenticateStudent(appleID: appleId, name: name, email: email) { result in
            DispatchQueue.main.async {
                self.isAuthenticating = false

                switch result {
                case .success(let airtableRecordId):
                    print("Sucesso ao registrar o aluno: \(airtableRecordId)")
                    self.studentId = airtableRecordId
                case .failure(let error):
                    self.errorMessage = "Erro ao cadastrar o aluno: \(error.localizedDescription)"
                }
            }
            
        }
    }
}

#Preview {
    LoginView()
}

