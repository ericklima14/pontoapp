//
//  FileRowView.swift
//  pontoapp
//
//  Created by Erick Costa on 04/12/25.
//

import SwiftUI

struct FileRowView: View {
    let attachment: AttachmentModel
    
    private var icon: String {
        switch attachment.type {
        case let type where type.conforms(to: .image):
            return "photo"
        case .pdf:
            return "text.document"
        default:
            return "document"
        }
    }
    
    var onRemove: () -> Void
    let gradientColors: LinearGradient = LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Image(systemName: icon)
                .foregroundStyle(gradientColors)
                .font(.title3)
            
            VStack(alignment: .leading) {
                Text(attachment.name)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.gray.opacity(0.8))
                    .font(.title3)
            }
        }
        .padding(12)
        .background(Color.bg900.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(gradientColors, lineWidth: 1)
        )
        .padding(.horizontal, 5)
    }
}

#Preview {
    FileRowView(attachment: AttachmentModel(name: "alguma coisa", data: Data(), type: .pdf)){
        
    }
}
