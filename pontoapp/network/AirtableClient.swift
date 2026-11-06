//
//  AirtableClient.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 30/09/26.
//
import Foundation

enum AirtableTable {
    case students
    case timelog
    case events
    case summary
    case vacationDates
    
    var url: String {
        switch self{
            case .students:
                return EnviromentVariables.urlStudentsTable
            case .timelog:
                return EnviromentVariables.urlTimelogTable
            case .events:
                return EnviromentVariables.urlEventsTable
            case .summary:
                return EnviromentVariables.urlSummaryTable
            case .vacationDates:
                return EnviromentVariables.urlVacationDates
        }
    }
}

enum AirtableError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidRequestBody
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Algo deu errado. Tente Novamente! (Invalid URL)"
        case .invalidResponse:
            return "Algo deu errado. Tente Novamente! (Invalid Response)"
        case .invalidRequestBody:
            return "Algo deu errado. Tente Novamente! (Invalid Request Body)"
        case .serverError(let statusCode):
            return "Não foi possível concluir agora. Tente Novamente (Server Error) - Status: \(statusCode)"
                
        }
    }
}

private struct AirtableRecordID: Decodable {
    let id: String
}

///Classe Client para fazer as requisições da API do AirTable e salvar as informações la
class AirtableClient: AirtableClientProtocol {
    private let urlSession: URLSession
    private let apiToken: String
    
    init(urlSession: URLSession = URLSession.shared, apiToken: String = EnviromentVariables.airtableApiToken) {
        self.urlSession = urlSession
        self.apiToken = apiToken
    }
    
    //funcao para fazer a requisicao
    private func send(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("ERRO AO FAZER REQUISIÇÃO AO AIRTABLE:")
            print("Resposta Inválida")
            throw AirtableError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("ERRO AO FAZER REQUISIÇÃO AO AIRTABLE:")
            print("Status Code - \(httpResponse.statusCode)")
            print("Body Response - \(String(data: data, encoding: .utf8) ?? "Não foi possivel recuperar o corpo da requisição")")
            throw AirtableError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
    
    //funcao para fazer construir a requisicao
    private func makeRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    //funcao para criar o corpo da requisicao
    private func makeBody(fields: [String: Any]) throws -> Data {
        let body: [String: Any] = [
            "fields": fields,
            "typecast": true
        ]
        
        guard JSONSerialization.isValidJSONObject(body) else {
            throw AirtableError.invalidRequestBody
        }
        
        return try JSONSerialization.data(withJSONObject: body)
    }
    
    ///Funcao para requisicoes GET do airtable
    ///
    ///<F: Decodable>: serve para que o compilador saiba que o tipo generico F
    ///pode ser decodificado. Uma vez que precisamos retornar um tipo genérico
    func list<F: Decodable>(_ table: AirtableTable, formula: String? = nil, fields: [String] = []) async throws -> [AirtableRecord<F>] {
        
        guard var urlComponents = URLComponents(string: table.url) else {
            throw AirtableError.invalidURL
        }
        
        var urlQueryItems: [URLQueryItem] = []
        
        for field in fields {
            urlQueryItems.append(URLQueryItem(name: "fields[]", value: field))
        }
        
        if let formula {
            urlQueryItems.append(URLQueryItem(name: "filterByFormula", value: formula))
        }
        
        var response: [AirtableRecord<F>] = []
        var offsetPagination: String? = nil
        
        repeat {
            var urlQueryItemsCopy = urlQueryItems
            
            if let offsetPagination {
                urlQueryItemsCopy.append(URLQueryItem(name: "offset", value: offsetPagination))
            }
            
            urlComponents.queryItems = urlQueryItemsCopy
            
            guard let url = urlComponents.url else {
                throw AirtableError.invalidURL
            }
            
            let urlRequest = makeRequest(url: url, method: "GET")
           
            let dataResponse = try await send(urlRequest)
            
            let decoded = try JSONDecoder().decode(AirtableResponse<F>.self, from: dataResponse)
            offsetPagination = decoded.offset
            response.append(contentsOf: decoded.records)
        
        } while offsetPagination != nil
        
        return response
    }
    
    ///funcao para requisicoes PATCH - atualiza um registro no airtable atraves do recordID.
    func update(_ table: AirtableTable, recordID: String, fields: [String: Any]) async throws {
        guard let url = URL(string: "\(table.url)/\(recordID)") else {
            throw AirtableError.invalidURL
        }
        
        var urlRequest = makeRequest(url: url, method: "PATCH")
        
        urlRequest.httpBody = try makeBody(fields: fields)
        
        _ = try await send(urlRequest)
    }
    
    ///funcao para requisicoes POST - cria um registro no airtable
    func create(_ table: AirtableTable, fields: [String: Any]) async throws -> String {
        guard let url = URL(string: table.url) else {
            throw AirtableError.invalidURL
        }
        
        var urlRequest = makeRequest(url: url, method: "POST")
        
        urlRequest.httpBody = try makeBody(fields: fields)
        
        let response = try await send(urlRequest)
        let recordID = try JSONDecoder().decode(AirtableRecordID.self, from: response)
        
        return recordID.id
    }
}
