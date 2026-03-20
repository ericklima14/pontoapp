//
//  WebService.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import Foundation

class WebService: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "AirtableToken") as? String ?? ""
    
    func authenticateStudent(appleID: String, name: String, email: String, completion: @escaping(Result<String, Error>) -> Void){
        print("Iniciando a busca:")
        print("ESTUDANTE - \(name)")
        print("APPLEID - \(appleID)")
        print("EMAIL - \(email)")
        
        fetchStudentExistence(appleUserID: appleID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let id):
                if let id = id {
                    print("Estudante já cadastrado. ID: \(id)")
                    completion(.success(id))
                } else {
                    let studentRecord = StudentRecord(appleID: appleID, name: name, memojiURL: [], email: email)
                    self.postNewStudent(studentRecord: studentRecord) { result in
                        switch result {
                        case .success(let newId):
                            print("Estudante cadastrado com sucesso. ID: \(newId)")
                            completion(.success(newId))
                        case .failure(let error):
                            print("Erro ao cadastrar estudante: \(error)")
                            completion(.failure(error))
                        }
                    }
                    
                }
            case .failure(let error):
                print("Erro ao buscar estudante: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchStudentExistence(appleUserID: String, completion: @escaping (Result<String?, Error>) -> Void) {
        let baseURL = "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/tblAa5f96kWbKt3Rn"
        guard var components = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL base inválida"])))
            return
        }
        
        let formula = "{AppleID} = '\(appleUserID)'"
        components.queryItems = [
            URLQueryItem(name: "filterByFormula", value: formula)
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Falha ao montar parâmetros da URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"])))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let jsonErro = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("ERRO DO AIRTABLE: \(jsonErro)")
                }
                
                let erro = NSError(
                    domain: "APIError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Erro no servidor. Status \(httpResponse.statusCode)"]
                )
                
                completion(.failure(erro))
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let records = json["records"] as? [[String: Any]] {
                        
                        if let firstRecord = records.first, let recordId = firstRecord["id"] as? String {
                            
                            completion(.success(recordId))
                        } else {
                            completion(.success(nil))
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Falha ao ler JSON do Airtable"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()

    }
    
    func updateStudentMemoji(recordId: String, memojiPublicUrl: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/tblAa5f96kWbKt3Rn/\(recordId)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let fields: [String: Any] = [
            "Memoji": [
                ["url": memojiPublicUrl]
            ]
        ]
        
        let body: [String: Any] = [
            "fields": fields,
            "typecast": true
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Erro ao atualizar"])))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func postNewStudent(studentRecord: StudentRecord, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/tblAa5f96kWbKt3Rn") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        var fields: [String: Any] = [
            "AppleID": studentRecord.appleID,
            "Name": studentRecord.name,
            "Email": studentRecord.email
        ]
        
        let body: [String: Any] = [
            "fields": fields,
            "typecast": true
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"])))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let jsonErro = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("ERRO DO AIRTABLE: \(jsonErro)")
                }
                
                let erro = NSError(
                    domain: "APIError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Erro no servidor. Status \(httpResponse.statusCode)"]
                )
                
                completion(.failure(erro))
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let newRecordId = json["id"] as? String {
                        completion(.success(newRecordId))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Falha ao ler ID criado no JSON"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func postRecord(record: RecordModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/tblkNzlaXHa3x5SVr") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        var fields: [String: Any] = [
            "latitude": record.latitude,
            "longitude": record.longitude,
            "student": [record.studentId],
            "datetime": Date.dateTimeNow(),
            "Status": record.status.rawValue
        ]
        
        if let justifyText = record.justifyText, !justifyText.isEmpty {
            fields["Justify"] = justifyText
        }
        
        if let files = record.filesURL, !files.isEmpty {
            let attachmentsArray = files.map { url in
                return ["url": url]
            }
            
            fields["Attach"] = attachmentsArray
        }
        
        let body: [String: Any] = [
            "fields": fields,
            "typecast": true
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"])))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let jsonErro = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("ERRO DO AIRTABLE: \(jsonErro)")
                }
                
                let erro = NSError(
                    domain: "APIError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Erro no servidor. Status \(httpResponse.statusCode)"]
                )
                
                completion(.failure(erro))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func fetchCalendar(studentId: String, month: Int, year: Int, completion: @escaping (Result<[Int: RecordStatus], Error>) -> Void) {
        let baseURL = "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/Timelog"
        var components = URLComponents(string: baseURL)
        
        components?.queryItems = [
            URLQueryItem(name: "filterByFormula", value: "AND(SEARCH('\(studentId)', {Record ID (from student)} & ''), MONTH({datetime}) = \(month), YEAR({datetime}) = \(year))")
        ]
        
        guard let url = components?.url else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(AirtableCalendarResponse.self, from: data)
                
                var calendarInfos: [Int: RecordStatus] = [:]
                
                for record in decodedResponse.records {
                    if let date = self.isoFormatter.date(from: record.fields.datetime) {
                        let day = Calendar.current.component(.day, from: date)
                        let status = RecordStatus(rawValue: record.fields.status)
                        
                        calendarInfos[day] = status
                    }
                }
                
                completion(.success(calendarInfos))
            } catch {
                print("Erro ao decodificar: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        let baseURL = "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/Eventos"
        
        var components = URLComponents(string: baseURL)
        
        let filterFormula = "{Datetime} >= TODAY()"
        
        components?.queryItems = [
            URLQueryItem(name: "filterByFormula", value: filterFormula),
            URLQueryItem(name: "sort[0][field]", value: "Datetime"),
            URLQueryItem(name: "sort[0][direction]", value: "asc")
        ]
        
        guard let url = components?.url else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dados não encontrados"])
                    self?.errorMessage = "Dados não encontrados"
                    completion(.failure(error))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AirtableResponse.self, from: data)
                    self?.events = result.records
                    completion(.success(result.records))
                } catch {
                    self?.errorMessage = "Erro ao processar dados"
                    completion(.failure(error))
                }

            }
        }.resume()
    }

}
