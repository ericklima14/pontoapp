import SwiftUI

struct SliderFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct RegisterView: View {
    
    @AppStorage("studentId") private var studentId: String = "k"
    @AppStorage("hasCompletedTutorial") private var hasCompletedTutorial: Bool = false
    @AppStorage("hasCompletedFirstCheckIn") private var hasCompletedFirstCheckIn: Bool = false
    
    @State private var justifyAbstence: Bool = false
    @State private var justifyLate: Bool = false
    @State private var showSettings = false
    
    @State private var sliderFrame: CGRect = .zero
    @State private var tutorialVisible: Bool = !UserDefaults.standard.bool(forKey: "hasCompletedTutorial")

    @EnvironmentObject private var viewModel: RegistrationViewModel
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var beaconManager = BeaconManager.shared
    @StateObject var profileController = ProfileController()
    
    private var profileImage: Image? {
        profileController.profileImage ?? Image(systemName: "person.circle.fill")
    }
    
    var body: some View {
        if studentId.isEmpty {
            noStudentIdView
        } else {
            ZStack {
                VStack(spacing: 20) {
                    registerCommand
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bg950)
                .disabled(tutorialVisible)
                                
                if !hasCompletedTutorial && sliderFrame != .zero {
                    OnboardingOverlayView(
                        hasCompletedTutorial: $hasCompletedTutorial,
                        sliderFrame: sliderFrame
                    )
                }
            }
            .toolbar(tutorialVisible ? .hidden : .visible, for: .tabBar)
            .onChange(of: hasCompletedTutorial) {
                // Delay igual ao da animação de saída do overlay (0.5s)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        tutorialVisible = false
                    }
                }
            }
            .coordinateSpace(name: "registerView")
            .onPreferenceChange(SliderFramePreferenceKey.self) { frame in
                print("📍 Slider frame: \(frame)")
                sliderFrame = frame
            }
            .navigationTitle("Registros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(isPresented: $justifyLate) {
                JustifyView(titleText: "Justificar Atraso", subtitleText: "Motivo de seu atraso:") { text, files in
                    viewModel.requestCheckIn(studentId: studentId, status: .lated, location: locationManager.userLocation, justifyText: text, files: files)
                    
//                    let today = Date.now
//                    viewModel.getCalendarInfos(month: today.month, year: today.year)
                    
                    justifyLate = false
                }
            }
            .navigationDestination(isPresented: $justifyAbstence) {
                JustifyView(titleText: "Justificar Ausência", subtitleText: "Motivo de sua ausência:") { text, files in
                    viewModel.requestCheckIn(studentId: studentId, status: .absent, location: locationManager.userLocation, justifyText: text, files: files)
                    
//                    let today = Date.now
//                    viewModel.getCalendarInfos(month: today.month, year: today.year)
                    
                    justifyAbstence = false
                }
            }
            .fullScreenCover(isPresented: $viewModel.showSuccess) {
                RegisterSuccessView(text: viewModel.successMessage)
            }
            .alert("Erro", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Ocorreu um erro inesperado")
            }
            .alert("Fora da Academy", isPresented: $viewModel.showOutsideAcademyAlert) {
                Button("Registrar mesmo assim", role: .destructive) {
                    viewModel.confirmCheckInOutsideAcademy()
                }
                Button("Cancelar", role: .cancel) {
                    viewModel.cancelCheckIn()
                }
            } message: {
                Text("Você parece estar fora da Apple Developer Academy. Deseja registrar o ponto mesmo assim?")
            }
            .onAppear {
                viewModel.resetToCurrentMonth()
                beaconManager.startMonitoring()
            }
        }
    }
    
    var registerCommand: some View {
        VStack {
            Spacer()
            
            CalendarView(
                currentDate: $viewModel.currentCalendarDate,
                daysCheckedIn: $viewModel.calendarStatus, daysWithEvents: $viewModel.daysWithEvents) { month, year in
                    viewModel.getCalendarInfos(month: month, year: year)
                } onDateSelected: { date in
                    viewModel.fetchDayDetail(date: date)
                }
                .overlay {
                    if viewModel.isLoadingCalendar {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .tint(.gradientStart)
                            )
                    }
                }
                .sheet(item: $viewModel.selectedDayDetail){ detail in
                    DayDetailSheet(detail: detail)
                }
            
            Spacer()
            
            Group {
                checkInContent
            }
            .layoutPriority(1)
            .onAppear {
                Task { await viewModel.loadCheckInWindowState() }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task { await viewModel.loadCheckInWindowState() }
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var checkInContent: some View {
        if viewModel.hasAlreadyCheckedInToday() {
            CardCheckedInView(text: viewModel.nextValidDayMessage())
            
        } else if !hasCompletedFirstCheckIn || viewModel.checkInWindowState == .open {
            PresenceSlider(profileImage: profileImage, onSwipeRight: {
                LocalAuthService().authorizeUser { authenticated in
                    guard authenticated else { return }
                    Task {
                        let result = await viewModel.validateWithServerTime()
                        await MainActor.run {
                            switch result {
                            case .onTime:
                                viewModel.requestCheckIn(
                                    studentId: studentId,
                                    status: .present,
                                    location: locationManager.userLocation
                                )
                                
                            case .late:
                                if !hasCompletedFirstCheckIn {
                                    viewModel.requestCheckIn(
                                        studentId: studentId,
                                        status: .present,
                                        location: locationManager.userLocation,
                                        justifyText: "Primeiro check-in realizado usando o aplicativo de presença - Stemp"
                                    )
                                    hasCompletedFirstCheckIn = true
                                    
                                } else {
                                    justifyLate = true
                                }
                                
                            case .outsideWindow:
                                if !hasCompletedFirstCheckIn {
                                    viewModel.requestCheckIn(
                                        studentId: studentId,
                                        status: .present,
                                        location: locationManager.userLocation,
                                        justifyText: "Primeiro check-in realizado usando o aplicativo de presença - Stemp"
                                    )
                                    hasCompletedFirstCheckIn = true
                                } else {
                                    viewModel.errorMessage = "Fora do horário permitido (13:40–18:00)"
                                    viewModel.showError = true
                                }
                            case .invalidDay:
                                viewModel.errorMessage = "Não é um dia válido para registro."
                                viewModel.showError = true
                                
                            case .error:
                                viewModel.errorMessage = "Erro ao verificar horário. Verifique sua conexão."
                                viewModel.showError = true
                            }

//                            let today = Date.now
//                            viewModel.getCalendarInfos(month: today.month, year: today.year)
                        }
                    }
                }
            }, onSwipeLeft: {
                LocalAuthService().authorizeUser { authenticated in
                    guard authenticated else { return }
                    justifyAbstence = true
                }
            })
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: SliderFramePreferenceKey.self,
                            value: proxy.frame(in: .named("registerView"))
                        )
                }
            )
            .padding(.bottom, tutorialVisible ? 70 : 0)
            .layoutPriority(1)
            
        } else {
            switch viewModel.checkInWindowState {
            case .loading:
                ProgressView()
                    .tint(.gradientStart)
                    .frame(maxWidth: .infinity)
            default:
                CardCheckInWindowClosedView(text: viewModel.nextValidDayMessage())
            }
        }
    }
    
    var noStudentIdView: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)
            
            Text("Student ID não configurado")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Por favor, configure seu Student ID nas configurações para registrar presença.")
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bg950)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(RegistrationViewModel())
}
