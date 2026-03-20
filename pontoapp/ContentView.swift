//
//  ContentView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 05/11/24.
//

import SwiftUI

enum OnboardingStep {
    case location
    case contacts
    case login
    case completed
}

struct ContentView: View {
    @AppStorage("appleID") var userId: String?
    @AppStorage("email") var email: String?
    @AppStorage("hasSelectedMemoji") var hasSelectedMemoji: Bool = false
    @ObservedObject var locationManager = LocationManager.shared
    
    private var currentStep: OnboardingStep {
        if userId != nil && locationManager.userLocation != nil && hasSelectedMemoji {
            return .completed
        }
        
        if userId != nil && locationManager.userLocation != nil { return .contacts
        }
        
        if locationManager.userLocation == nil { return .location }
        
        return .login
    }
    
    private var isSignedIn: Bool {
        return userId != nil
    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.bg900)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        ZStack{
            Color.bg950.ignoresSafeArea()
            
            Group {
                switch currentStep {
                    case .location:
                        LocationRequestView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    case .contacts:
                        ProfileSetupView(userEmailApple: email ?? "")
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    case .login:
                        LoginView()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    case .completed:
                        AppTabBarView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: currentStep)
        }
    }
    
}

struct AppTabBarView: View {
    var body: some View {
        TabView {
            NavigationStack{
                RegisterView()
            }
            .tabItem {
                Image(systemName: "person.fill.checkmark")
                Text("Registrar")
            }
            
            DashboardView()
                .tabItem {
                    Image(systemName: "rectangle.3.offgrid")
                    Text("Dashboard")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Configurações")
                }
        }
        
        .accentColor(Color.gradientStart)
    }
}


#Preview {
    ContentView()
}
