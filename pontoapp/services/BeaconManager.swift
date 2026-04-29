//
//  BeaconManager.swift
//  pontoapp
//
//  Created by Erick Costa on 28/04/26.
//

import CoreLocation
import UserNotifications

class BeaconManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    static let shared = BeaconManager()
    
    private let academyUUID = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
    
    @Published var isInsideAcademy = false
    private var monitor: CLMonitor?

    //para pegar a proximidade dos beacons
    private var beaconRegion: CLBeaconRegion?
        
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startMonitoring(){
        guard monitor == nil else {
            print("Monitor já está ativo")
            return
        }
        
        manager.requestAlwaysAuthorization()
        startRanging()
        
        Task{
            let monitor = await CLMonitor("AcademyBeaconMonitor")
            
            await monitor.add(CLMonitor.BeaconIdentityCondition(uuid: academyUUID), identifier: "Academy")
            
            self.monitor = monitor
            
            for try await event in await monitor.events {
                await MainActor.run {
                    switch event.state {
                    case .satisfied:
                        print("Beacon detectado — aguardando confirmação de proximidade")
                    case .unsatisfied, .unknown:
                        self.isInsideAcademy = false
                        print("Aluno saiu da Academy")
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func stopMonitoring(){
        Task{
            await monitor?.remove("Academy")
            monitor = nil
        }
    }
    
    private func startRanging(){
        let region = CLBeaconRegion(uuid: academyUUID, identifier: "Academy")
        self.beaconRegion = region
        manager.startRangingBeacons(satisfying: region.beaconIdentityConstraint)
    }
    
    private func stopRanging(){
        guard let region = beaconRegion else { return }
        manager.stopRangingBeacons(satisfying: region.beaconIdentityConstraint)
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        let validBeacons = beacons.filter {
            $0.proximity == .near || $0.proximity == .immediate
        }
        
        DispatchQueue.main.async {
            self.isInsideAcademy = !validBeacons.isEmpty
            
            if !validBeacons.isEmpty {
                print("Aluno dentro da Academy — proximidade: \(validBeacons.first!.proximity.rawValue)")
            } else {
                print("Nenhum beacon próximo o suficiente")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Permissão Always concedida")
            startMonitoring()
        case .authorizedWhenInUse:
            print("Permissão apenas WhenInUse — solicitando Always")
            manager.requestAlwaysAuthorization()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.isInsideAcademy = false
            }
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro no BeaconManager: \(error.localizedDescription)")
    }
}
