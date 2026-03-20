//
//  ProfilePictureView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 19/02/26.
//

import SwiftUI

struct ProfileSetupView: View {
    @State var userEmailApple: String
    @StateObject private var viewModel = ProfileSetupViewModel()
    @AppStorage("hasSelectedMemoji") var hasSelectedMemoji: Bool = false
    @AppStorage("memoji") var memojiSelected: String = ""
    @State private var showContactPicker = false
    @State private var profileImage: UIImage?
    @State private var scaleEffect: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var isUploading = false
    
    var body: some View {
        ZStack{
            Color.bg950.ignoresSafeArea()
            
            VStack{
                Text("Apple Academy")
                    .fontWeight(.semibold)
                    .foregroundColor(.white).opacity(0.9)
                    .font(.system(size: 40))
                
                Text("SENAC")
                    .fontWeight(.semibold)
                    .foregroundColor(.white).opacity(0.7)
                    .font(.system(size: 30))
                
                Spacer()
                
                Group {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gradientStart, lineWidth: 2))
                    } else {
                        LoopingPlayerView(videoName: "memojiVideo2", videoType: "mp4")
                            .frame(width: 200, height: 200)
                            .shadow(radius: 10)
                    }
                }
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
                
                
                Text("Permita o acesso a sua lista de contatos para selecionar o seu Memoji do seu card de contatos para uma experiência única e personalizada dentro do app!")
                    .fontWeight(.semibold)
                    .foregroundColor(.white).opacity(0.7)
                    .padding(.horizontal, 25)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: {
                    if profileImage == nil {
                        ContactPicker.fetchMeCard(emailAddress: userEmailApple){ contato in
                            DispatchQueue.main.async {
                                if let imagePath = contato?.imageData,  let imageTransformed = UIImage(data: imagePath) {
                                    viewModel.saveProfileImage(profileImage: imageTransformed)
                                    profileImage = imageTransformed
                                }
                            }
                        }
                    } else {
                        isUploading = true
                        
                        viewModel.sendMemojiToDropbox { sucesso in
                            DispatchQueue.main.async {
                                isUploading = false
                                if sucesso {
                                    withAnimation(.easeInOut){
                                        hasSelectedMemoji = true
                                    }
                                } else {
                                    print("Erro no upload. Tente novamente.")
                                }
                            }
                        }
                    }
                }) {
                    if isUploading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gradientEnd))
                    } else{
                        Text(profileImage == nil ? "Permitir" : "Continuar")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 80)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.gradientStart,
                                        Color.gradientEnd
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                    }
                }
                .disabled(isUploading)
                .padding(.bottom, 40)
            }
        }
    }
    

}

#Preview {
    ProfileSetupView(userEmailApple: "")
}
