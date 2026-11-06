//
//  FileModel.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 04/11/26.
//
import Foundation
import UniformTypeIdentifiers

struct AttachmentModel: Identifiable {
    let id = UUID()
    let name: String
    let data: Data
    //usado para identificar o tipo de arquivo
    let type: UTType
}

extension AttachmentModel {
    init(url: URL) throws {
        let grantedAccess = url.startAccessingSecurityScopedResource()
        
        defer {
            if grantedAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        self.data = try Data(contentsOf: url)
        self.name = url.lastPathComponent
        self.type = UTType(filenameExtension: url.pathExtension) ?? .data
    }
}
