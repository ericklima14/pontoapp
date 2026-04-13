//
//  SettingsViews.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 07/11/24.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @AppStorage("studentId") private var studentId: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("userId") private var userId: String?
    
    @StateObject var profileController = ProfileController()
    
    var body: some View {
        ZStack{
            Color.bg950.ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(spacing: 28) {
                    heroSection
                    academySection
                    appSection
                    footer
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 48)
            }
        }
        .navigationTitle("Perfil")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // MARK: - Hero
    
    private var heroSection: some View {
        VStack(spacing: 10) {
            ZStack {
                if let image = profileController.profileImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white.opacity(0.2))
                }
            }
            .padding(.top, 16)
            
            Text(name.isEmpty ? "Aluno" : name)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
            
            Text(studentId.isEmpty ? "ID não configurado" : "ID: \(studentId)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "#1D9E75"))
                .padding(.horizontal, 11)
                .padding(.vertical, 3)
                .background(Color(hex: "#1D9E75").opacity(0.1))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color(hex: "#1D9E75").opacity(0.25), lineWidth: 0.5))
            
            Text("Turma \(Date.classDurationInYears())")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.35))
        }
    }
    
    private var academySection: some View {
        ProfileSection(label: "Academy") {
            NavigableRow(icon: "apple.logo", iconBg: .blue, title: "Sobre a Academy", destinationView: AboutAcademyView())
            NavigableRow(icon: "list.clipboard.fill", iconBg: .amber, title: "Regras da Academy", destinationView: AcademyRulesView())
            NavigableRow(icon: "environments.fill", iconBg: .amber, title: "Regras sobre o espaço da Academy", destinationView: EnviromentRulesView())
            NavigableRow(icon: "desktopcomputer", iconBg: .gray, title: "Regras sobre os Equipamentos", destinationView: DeviceRulesView())
            NavigableRow(icon: "star.fill", iconBg: .green, title: "Manifesto", destinationView: ManifestView())
        }
    }
    
    private var appSection: some View {
        ProfileSection(label: "Sobre o App") {
            NavigableRow(icon: "doc.text.fill", iconBg: .gray, title: "Termos de Uso", destinationView: UserTermsView())
            NavigableRow(icon: "lock.fill", iconBg: .gray, title: "Política de Privacidade", destinationView: PrivacyPolicyView())
            InfoRow(icon: "gearshape.fill", iconBg: .blue, title: "1.0.0 (build 42)", subtitle: "Versão do App")
        }
    }
        
    private var footer: some View {
        VStack(spacing: 2) {
            Text("Ponto App · Apple Developer Academy")
            Text("São Paulo, SP")
        }
        .font(.system(size: 11))
        .foregroundColor(.white.opacity(0.18))
    }
}

// MARK: - ProfileSection

struct ProfileSection<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))
                .kerning(0.6)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))

        }
    }
}

// MARK: - InfoRow (sem chevron, só exibe dado)

struct InfoRow: View {
    let icon: String
    let iconBg: ProfileIconColor
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 15) {
            ProfileIcon(systemName: icon, color: iconBg)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.35))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.white.opacity(0.06)).frame(height: 0.5)
        }
    }
}

// MARK: - NavigableRow (com chevron, abre sheet/nav)

struct NavigableRow<Destination: View>: View {
    let icon: String
    let iconBg: ProfileIconColor
    let title: String
    let destinationView: Destination
    
    var body: some View {
        NavigationLink(destination: destinationView) {
            HStack(spacing: 15) {
                ProfileIcon(systemName: icon, color: iconBg)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.2))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .overlay(alignment: .bottom) {
                Rectangle().fill(Color.white.opacity(0.06)).frame(height: 0.7)
            }
        }
    }
}

// MARK: - ProfileIcon

enum ProfileIconColor { case green, blue, amber, gray, red }

struct ProfileIcon: View {
    let systemName: String
    let color: ProfileIconColor
    
//    private var bg: Color {
//        switch color {
//        case .green: return Color(hex: "#1D9E75").opacity(0.12)
//        case .blue:  return Color(hex: "#378ADD").opacity(0.12)
//        case .amber: return Color(hex: "#EF9F27").opacity(0.10)
//        case .gray:  return Color.white.opacity(0.07)
//        case .red:   return Color(hex: "#D85A30").opacity(0.10)
//        }
//    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0)).frame(width: 30, height: 0)
            Image(systemName: systemName)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.65))
        }
        
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
