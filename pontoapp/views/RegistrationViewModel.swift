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
    
    private var studentId: String = ""
    private var studentName: String = ""

    private let webService = WebService()
    private let dropboxService = DropboxService()
    
    init(){
        intialConfig()
    }
    
    func intialConfig(){
        self.studentId = UserDefaults.standard.string(forKey: "studentId") ?? ""
        self.studentName = UserDefaults.standard.string(forKey: "name") ?? ""
    }
    
    func loadInitialData() {
        let today = Date.now

        if calendarStatus.isEmpty {
            getCalendarInfos(month: today.month, year: today.year)
        }
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
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            }
        }
    }
}
