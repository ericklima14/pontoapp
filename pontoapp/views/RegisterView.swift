import SwiftUI

struct RegisterView: View {

    @AppStorage("studentId") private var studentId: String = "k"

    @State private var justifyAbstence: Bool = false
    @State private var justifyLate: Bool = false
    @State private var showSettings = false

    @EnvironmentObject private var viewModel: RegistrationViewModel
    @ObservedObject var locationManager = LocationManager.shared
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
            }
            .navigationTitle("Agenda")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(isPresented: $justifyLate) {
                JustifyView(titleText: "Justificar Atraso", subtitleText: "Motivo de seu atraso:") { text, files in
                    viewModel.requestCheckIn(studentId: studentId, status: .lated, location: locationManager.userLocation, justifyText: text, files: files)
                    
                    let today = Date.now
                    viewModel.getCalendarInfos(month: today.month, year: today.year)
                    
                    justifyLate = false
                }
            }
            .navigationDestination(isPresented: $justifyAbstence) {
                JustifyView(titleText: "Justificar Ausência", subtitleText: "Motivo de sua ausência:") { text, files in
                    viewModel.requestCheckIn(studentId: studentId, status: .absent, location: locationManager.userLocation, justifyText: text, files: files)
                    
                    let today = Date.now
                    viewModel.getCalendarInfos(month: today.month, year: today.year)
                    
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
                viewModel.loadInitialData()
            }
        }
    }

    var registerCommand: some View {
        VStack {
            Spacer()

            CalendarView(daysCheckedIn: $viewModel.calendarStatus, daysWithEvents: $viewModel.daysWithEvents) { month, year in
                viewModel.getCalendarInfos(month: month, year: year)
            } onDateSelected: { date in
                viewModel.fetchDayDetail(date: date)
            }
            .sheet(item: $viewModel.selectedDayDetail){ detail in
                DayDetailSheet(detail: detail)
            }

            Spacer()

            Group {
                if viewModel.isChekInWindowOpen() && !viewModel.hasAlreadyCheckedInToday() {
                    PresenceSlider(profileImage: profileImage, onSwipeRight: {
                        LocalAuthService().authorizeUser { authenticated in
                            if authenticated {
                                if viewModel.isOnTime() {
                                    viewModel.requestCheckIn(
                                        studentId: studentId,
                                        status: .present,
                                        location: locationManager.userLocation
                                    )
                                    let today = Date.now
                                    viewModel.getCalendarInfos(month: today.month, year: today.year)
                                    
                                } else {
                                    justifyLate = true
                                }
                            }
                        }

                    }, onSwipeLeft: {
                        LocalAuthService().authorizeUser { authenticated in
                            if authenticated {
                                justifyAbstence = true
                            }
                        }
                    })
                } else if viewModel.hasAlreadyCheckedInToday() {
                    CardCheckedInView(text: viewModel.nextValidDayMessage())
                } else {
                    CardCheckInWindowClosedView(text: viewModel.nextValidDayMessage())
                }
            }
            .layoutPriority(1)

            Spacer()
        }
        //.ignoresSafeArea(edges: .top)
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
