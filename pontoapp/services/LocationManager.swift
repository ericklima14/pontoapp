//
//  LocationManager.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 08/11/24.
//

import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject{
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var permissionDenied = false
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        requestSendUserNotification()
        monitorarGeofence()
    }
    
    func requestLocation(){
        manager.requestAlwaysAuthorization()
    }
    
    
    func monitorarGeofence(){
        //coordenadas da academy
        let center = CLLocationCoordinate2D(latitude: -23.668777973166964, longitude: -46.6992374689516)
        let maxRadius = 20.0
        
        let region = CLCircularRegion(center: center, radius: maxRadius, identifier: "Academy")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        manager.startMonitoring(for: region)
    }
    
    private func requestSendUserNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Erro ao pedir permissão de notificação: \(error)")
            }
        }
    }
    
    private func sendUserNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hora de bater o ponto!"
        content.body = "Você chegou na Academy, não esqueça de bater seu ponto."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "PontoNotificacao", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func isOnTime() -> Bool{
        let time = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        let nowMinutes = hour * 60 + minute
        
        //13:30 até 14:30
        let startMinutes: Int = 13 * 60 + 30
        let endMinutes: Int = 14 * 60 + 30
        
        return nowMinutes >= startMinutes && nowMinutes <= endMinutes
        
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        case .denied:
            permissionDenied = true
        case .authorizedAlways:
            print("Authorized Always")
        case .authorizedWhenInUse:
            print("Authorized When In Use")
        @unknown default:
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if region.identifier == "Academy"{
            //if isOnTime(){
                print("ENTROU na região no horário: \(region.identifier)")
                sendUserNotification()
            //} else {
//                print("Entrou na região, mas fora do horário (13:30 - 14:30).")
//            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("SAIU da região: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Falha ao monitorar região: \(error.localizedDescription)")
    }
}
