//
//  RegistrationViewModel.swift
//  pontoapp
//
//  Created by Erick Costa on 19/01/26.
//

import Foundation
import CoreLocation

class RegistrationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var successMessage: String = ""
    @Published var calendarStatus: [Int: RecordStatus] = [:]
    @Published var isCheckedInToday: Bool = false
    @Published var selectedDayDetail: DayDetail? = nil
    @Published var isLoadingDayDetail: Bool = false
    @Published var daysWithEvents: [Int] = []
    
    @Published var showOutsideAcademyAlert: Bool = false
    private var pendingCheckIn: (() -> Void)?
    
    private var studentId: String {
        UserDefaults.standard.string(forKey: "studentId") ?? ""
    }
    
    private var studentName: String {
        UserDefaults.standard.string(forKey: "name") ?? ""
    }

    private let webService = WebService()
    private let dropboxService = DropboxService()
        
    func loadInitialData() {
        guard !studentId.isEmpty else { return }

        let today = Date.now

        if calendarStatus.isEmpty {
            getCalendarInfos(month: today.month, year: today.year)
            loadEvents()
        }
    }
    
    func isOnTime() -> Bool {
        let endMinutes: Int = 14 * 60 + 20
        return Date.getCurrentMinutes() <= endMinutes
    }

    func isChekInWindowOpen() -> Bool {
        guard isValidDay(Date()) else { return false }
        
        let beginMinutes: Int = 13 * 60 + 40
        let endMinutes: Int   = 18 * 60
        let currentMinutes = Date.getCurrentMinutes()
        
        return currentMinutes >= beginMinutes && currentMinutes < endMinutes
    }
    
    func isValidDay(_ date: Date) -> Bool{
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let key = String(format: "%02d-%02d", day, month)
        
        let isWeekend = calendar.isDateInWeekend(date)
        let isHoliday = HolidayManager.shared.getHolidays(for: year)[key] != nil
        
        return !isWeekend && !isHoliday
    }
    
    func nextValidDay() -> Date{
        let calendar = Calendar.current
        var candidate = calendar.startOfDay(for: Date())
        
        if isValidDay(candidate) && Date.getCurrentMinutes() < 13 * 60 + 40 {
            return candidate
        }
        
        for _ in 1...8 {
            candidate = calendar.date(byAdding: .day, value: 1, to: candidate)!
            if isValidDay(candidate) {
                return candidate
            }
        }
        
        return candidate
    }
    
    func nextValidDayMessage() -> String {
        let next = nextValidDay()
        let calendar = Calendar.current
        
        if calendar.isDateInTomorrow(next) {
            return "Volte amanhã às 13:40 para bater seu ponto"
        }
        
        if calendar.isDateInToday(next) {
            return "Volte às 13:40 para bater seu ponto"
        }
        
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "pt_BR")
        fmt.dateFormat = "EEEE, d 'de' MMMM"
        
        return "Volte em \(fmt.string(from: next).capitalized) às 13:40 para bater seu ponto"
    }
    
    func hasAlreadyCheckedInToday() -> Bool {
        return isCheckedInToday
    }
    
    func loadEvents() {
        webService.fetchEvents { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let events):
                    self?.updateDaysWithEvents(from: events)
                case .failure(let error):
                    print("Não foi possível atualizar os eventos no calendário. Erro: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateDaysWithEvents(from events: [EventDetail]) {
        self.daysWithEvents = events.map { event in
            Calendar.current.component(.day, from: event.time)
        }
    }
    
    func fetchDayDetail(date: Date) {
        isLoadingDayDetail = true

        let calendar = Calendar.current
        let year  = calendar.component(.year,  from: date)
        let month = calendar.component(.month, from: date)
        let day   = calendar.component(.day,   from: date)
        let key   = String(format: "%02d-%02d", day, month)
        let holidayName = HolidayManager.shared.getHolidays(for: year)[key]

        let group = DispatchGroup()
        var checkIn: CheckInDetail? = nil
        var events: [EventDetail]   = []

        group.enter()
        webService.fetchCheckInDetail(studentId: studentId, date: date) { result in
            if case .success(let detail) = result { checkIn = detail }
            group.leave()
        }

        group.enter()
        webService.fetchEventsForDay(date: date) { result in
            if case .success(let list) = result { events = list }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.isLoadingDayDetail = false
            self?.selectedDayDetail = DayDetail(
                date:    date,
                checkIn: checkIn,
                events:  events,
                holiday: holidayName
            )
        }
    }
    
    func requestCheckIn(studentId: String, status: RecordStatus, location: CLLocation?, justifyText: String? = nil, files: [URL]? = nil) {
        let locationManager = LocationManager.shared
 
        let checkInAction: () -> Void = { [weak self] in
            self?.registerEvent(
                studentId: studentId,
                status: status,
                location: location,
                justifyText: justifyText,
                files: files
            )
        }
 
        if locationManager.isInsideAcademy {
            checkInAction()
        } else {
            pendingCheckIn = checkInAction
            DispatchQueue.main.async {
                self.showOutsideAcademyAlert = true
            }
        }
    }
 
    func confirmCheckInOutsideAcademy() {
        pendingCheckIn?()
        pendingCheckIn = nil
    }
 
    func cancelCheckIn() {
        pendingCheckIn = nil
    }

    
    func registerEvent(studentId: String, status: RecordStatus, location: CLLocation?, justifyText: String? = nil, files: [URL]? = nil){
        guard let location = location else{
            DispatchQueue.main.async {
                self.errorMessage = "Localização não encontrada"
                self.showError = true
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        if let files = files, !files.isEmpty {
            uploadFilesToDropbox(files: files){ [weak self] dropboxFiles in
                DispatchQueue.main.async {
                    self?.sendToAirtable(studentId: studentId, status: status, location: location, justifyText: justifyText, fileLinks: dropboxFiles)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.sendToAirtable(studentId: studentId, status: status, location: location, justifyText: justifyText, fileLinks: nil)
            }
        }
    }
    
    func uploadFilesToDropbox(files: [URL], completion: @escaping ([String]) -> Void){
        let group = DispatchGroup()
        var uploadedLinks: [String] = []
        
        for file in files {
            group.enter()
            let accessGranted = file.startAccessingSecurityScopedResource()
            
            do{
                let fileData = try Data(contentsOf: file)
                let fileName = file.lastPathComponent
                
                dropboxService.uploadFileAndGetLink(studentId: self.studentId, studentName: self.studentName, fileData: fileData, fileName: fileName){ link in
                    if let link = link{
                        uploadedLinks.append(link)
                    }
                    
                    if accessGranted{
                        file.stopAccessingSecurityScopedResource()
                    }
                    group.leave()
                }
            } catch {
                print("Erro ao ler arquivo local: \(error.localizedDescription)")
                if accessGranted {
                    file.stopAccessingSecurityScopedResource()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(uploadedLinks)
        }
    }
        
    func getCalendarInfos(month: Int, year: Int){
        print("-------- O STUDENT ID É: \(self.studentId) ---------")
        print("-------- O STUDENT NAME É: \(self.studentName) ---------")
                
        webService.fetchCalendar(studentId: self.studentId, month: month, year: year) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let status):
                    self?.calendarStatus = status
                    
                    let now = Date()
                    if month == now.month && year == now.year {
                        let todayDay = now.day
                        
                        self?.isCheckedInToday = (status[todayDay] != nil)
                    }
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            }
            
        }
    }
    
    func sendToAirtable(studentId: String, status: RecordStatus, location: CLLocation, justifyText: String?, fileLinks: [String]?){
        
        let record = RecordModel(
            studentId: studentId,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            status: status,
            filesURL: fileLinks,
            justifyText: justifyText)
        
        webService.postRecord(record: record) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.successMessage = (status == .absent) ? "Falta justificada com sucesso!" : "Presença registrada com sucesso!"
                    self?.showSuccess = true
                    
                    self?.isCheckedInToday = true
                    NotificationCenter.default.post(name: NSNotification.Name("CheckInRealizado"), object: status)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            }
        }
    }
}
