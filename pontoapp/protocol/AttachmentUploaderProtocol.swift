//
//  AttachmentUploaderProtocol.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 09/11/26.
//

import Foundation

protocol AttachmentUploaderProtocol {
    func upload(attachment: AttachmentModel) async throws -> URL
}
