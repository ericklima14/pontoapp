//
//  EventDetailSheet.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 02/04/26.
//

import SwiftUI

struct EventDetailSheet: View {
    let event: EventDetail
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.bg950.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        // Header
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: event.colorHex ?? "#4067D0").opacity(0.15))
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Image(systemName: event.icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(hex: event.colorHex ?? "#4067D0"))
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.name)
                                    .font(.title2).fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(event.formattedDateTime)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }

                        // Descrição
                        if let desc = event.description, !desc.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Descrição", systemImage: "text.alignleft")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.4))
                                Text(desc)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.85))
                                    .lineSpacing(4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                        }

                        // Material de Apoio
                        if let materials = event.supportMaterial, !materials.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Label("Material de Apoio", systemImage: "folder")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.4))

                                ForEach(materials, id: \.id) { item in
                                    AttachmentRow(
                                        filename: item.filename,
                                        url: item.url,
                                        color: Color(hex: event.colorHex ?? "#4067D0")
                                    )
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                        }

                        // Links de Entrega
                        if let link = event.deliveryLinks {
                            VStack(alignment: .leading, spacing: 10) {
                                Label("Links de Entrega", systemImage: "arrow.up.doc")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.4))

                                //ForEach(links, id: \.self){ index, teste in
                                    LinksRow(
                                        link: link,
                                        color: Color(hex: event.colorHex ?? "#4067D0")
                                    )
                                //}
                                
//                                ForEach(links, id: \self.id) { item in
//                                    LinksRow(
//                                        link: item,
//                                        number: item.url,
//                                        color: Color(hex: event.colorHex ?? "#4067D0")
//                                    )
//                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Detalhes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct LinksRow: View {
    let link: String
    let color: Color
    
    var body: some View {
        if let link = URL(string: link) {
            Link(destination: link) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 18))
                        .foregroundColor(color)

                    Text("Link do Entregável")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(1)

                    Spacer()

                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.vertical, 6)
            }
        }
    }
}

struct AttachmentRow: View {
    let filename: String
    let url: String
    let color: Color

    var body: some View {
        if let link = URL(string: url) {
            Link(destination: link) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 18))
                        .foregroundColor(color)

                    Text(filename)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(1)

                    Spacer()

                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.vertical, 6)
            }
        }
    }
}

#Preview {
    let event = EventDetail(id: "1", name: "Challenge", time: Date.now, icon: "star.fill", colorHex: "#4067D0", description: "Lorem Ipsum", supportMaterial: [], deliveryLinks: "teste")

    EventDetailSheet(event: event)
}
