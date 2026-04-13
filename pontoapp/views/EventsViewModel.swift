//
//  EventsViewModel.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 26/03/26.
//

import Foundation

class EventsViewModel: ObservableObject {
    private let webService = WebService()
    @Published var events: [EventDetail] = []
    
    init(){
        fetchEvents()
    }
    
    func fetchEvents() {
        webService.fetchEvents { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self.events = events
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
