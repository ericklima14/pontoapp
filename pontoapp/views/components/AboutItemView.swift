//
//  AboutItemView.swift
//  pontoapp
//
//  Created by Erick Costa on 27/04/26.
//

import SwiftUI

struct AboutItemView: View {
    let item: AboutItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(item.letter.uppercased())
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.3))
                        .frame(width: 18)
                    
                    Text(item.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.2))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
            }
            
            if isExpanded {
                VStack(spacing: 10) {
                    Text(.init(item.body))
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.55))
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let content = item.view {
                        content
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 14)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.white.opacity(0.06)).frame(height: 0.5)
        }
    }
}
