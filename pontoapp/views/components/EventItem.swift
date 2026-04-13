//
//  EventItem.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 30/10/25.
//

import SwiftUI

struct EventItem: View {
    let eventInfos: EventDetail
    @State private var showDetail = false  // 👈 adiciona
    
    var body: some View {
        HStack{
            Rectangle()
                .foregroundStyle(Color(hex: eventInfos.colorHex ?? ""))
                .frame(width: 7)
            
            VStack(alignment: .leading){
                Text(eventInfos.name)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                Text(eventInfos.formattedDateTime)
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
            .padding(.leading, 5)
            
            Spacer()
            
            Image(systemName: eventInfos.icon)
                .font(.title2)
                .foregroundStyle(Color(hex: eventInfos.colorHex ?? ""))
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color.white.opacity(0.25))
                .padding(.leading, 10)
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.bg900))
        .padding(.horizontal, 5)
        .contentShape(Rectangle()) // 👈 área de toque cobre o card inteiro
        .onTapGesture { showDetail = true }
        .sheet(isPresented: $showDetail) {
            EventDetailSheet(event: eventInfos)
        }

    }
}

#Preview {
    let event = EventDetail(id: "1", name: "Challenge", time: Date.now, icon: "star.fill", colorHex: "#4067D0", description: "Lorem Ipsum", supportMaterial: [], deliveryLinks: "teste")
    
    ZStack{
        Color.bg950.ignoresSafeArea()
        
        EventItem(eventInfos: event)
    }
}

