import Foundation
import IOKit.ps
import Combine

class SystemMonitor: ObservableObject {
    @Published var batteryLevel: Int = 0
    @Published var isCharging: Bool = false
    private var timer: Timer?
    
    init() {
        updateBatteryStatus()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateBatteryStatus()
        }
    }
    
    func updateBatteryStatus() {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        
        for source in sources {
            if let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as? [String: Any] {
                let level = description[kIOPSCurrentCapacityKey] as? Int ?? 0
                let status = description[kIOPSPowerSourceStateKey] as? String
                let charging = (status == kIOPSACPowerValue)
                DispatchQueue.main.async {
                    self.batteryLevel = level
                    self.isCharging = charging
                }
            }
        }
    }
}