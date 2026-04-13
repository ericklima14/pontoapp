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
                
                
                Text("Permita o acesso a sua lista de contatos para selecionar o seu Memoji!")
                    .fontWeight(.semibold)
                    .foregroundColor(.white).opacity(0.7)
                    .padding(.horizontal, 25)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Group{
                    if isUploading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gradientEnd))
                    } else {
                        YellowButtonView(disabled: $isUploading, text: profileImage == nil ? "Permitir" : "Continuar", iconImage: nil){
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
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
    

}

#Preview {
    ProfileSetupView(userEmailApple: "")
}
