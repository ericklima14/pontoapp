//
//  AirtableClientProtocol.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 05/10/26.
//
import Foundation

protocol AirtableClientProtocol {
    func create(_ table: AirtableTable, fields: [String: Any]) async throws -> String
    
    func list<F: Decodable>(_ table: AirtableTable, formula: String?, fields: [String]) async throws -> [AirtableRecord<F>]
    
    func update(_ table: AirtableTable, recordID: String, fields: [String: Any]) async throws
}

extension AirtableClientProtocol {
    func list<F: Decodable>(_ table: AirtableTable) async throws -> [AirtableRecord<F>]{
        return try await list(table, formula: nil, fields: [])
    }
    
    func list<F: Decodable>(_ table: AirtableTable, formula: String) async throws -> [AirtableRecord<F>] {
        return try await list(table, formula: formula, fields: [])
    }
}
