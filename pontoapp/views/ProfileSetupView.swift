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
    @State private var isVideoReady: Bool = false
    @State private var textOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 10.0
    
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
                        LoopingPlayerView(videoName: "memojiVideo2", videoType: "mp4") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                                    scaleEffect = 1.0
                                    opacity = 1.0
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeOut(duration: 0.4)) {
                                    textOpacity = 1.0
                                    textOffset = 0
                                }
                            }
                        }
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                    }
                }
                .opacity(opacity)
                .scaleEffect(scaleEffect)
                
                
                Text("Permita o acesso a sua lista de contatos para selecionar o seu Memoji!")
                    .fontWeight(.semibold)
                    .foregroundColor(.white).opacity(0.7)
                    .padding(.horizontal, 25)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                    .offset(y: textOffset)
                
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
                                            
                                            withAnimation(.easeOut(duration: 0.25)) {
                                                scaleEffect = 0.8
                                                opacity = 0.0
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                scaleEffect = 0.8
                                                profileImage = imageTransformed
                                                
                                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                                    scaleEffect = 1.0
                                                    opacity = 1.0
                                                }
                                            }
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
