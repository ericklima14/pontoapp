//
//  MockUploader.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 09/11/26.
//

import Foundation

class MockUploader: AttachmentUploaderProtocol {
    func upload(attachment: AttachmentModel) async throws -> URL {
        guard let url = URL(string: "https://localhost:8001") else {
            throw UploadError.invalidURL
        }
        
        return url
    }
}
