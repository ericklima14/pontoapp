//
//  RegisterSuccessView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 06/11/24.
//

import SwiftUI

struct LocationRequestView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var scaleEffect: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            Color.bg950.ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 100, height: 100)
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
                
                
                Text($locationManager.permissionDenied.wrappedValue ?
                        "Acesse as configurações para permitir o uso da localização" :
                        "Vamos precisar da sua localização para continuar")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                
                Text("Suas coordenadas serão utilizadas para registrar a sua presença")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                if(!$locationManager.permissionDenied.wrappedValue) {
                    YellowButtonView(disabled: .constant(false), text: "Permitir", iconImage: nil){
                        LocationManager.shared.requestLocation()
                    }
                }
            }
        }
    }
}

#Preview {
    LocationRequestView()
}
