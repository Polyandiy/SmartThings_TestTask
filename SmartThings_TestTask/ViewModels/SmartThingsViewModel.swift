//
//  SmartThingsViewModel.swift
//  ListOfSmartThings_TestTask
//
//  Created by Поляндий on 30.10.2023.
//

import SwiftUI
import SVGView

class SmartThingsViewModel: ObservableObject {
    
    @Published var devices: [Device?] = []
    @Published var loadingStatus: LoadingStatus = .loading
    @Published var showAlert = false
    @State var selectedDevice: Device? = nil
    private var manager = SmartThingsRequest()
    let nameCache = "devices"
    
    init() {
        self.loadDevicesFromCache(withName: self.nameCache)
    }
    
    
    func loadDevicesFromCache(withName name: String) {
        
        if let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = cacheDirectory.appendingPathComponent(name)
            
            do {
                let data = try Data(contentsOf: fileURL)
                
                let devices = try JSONDecoder().decode([Device?].self, from: data)
                
                self.devices = devices
                withAnimation {
                    self.loadingStatus = .loaded
                }
                
            } catch {
                getData()
            }
        } else {
            getData()
        }
    }
    
    
    func getData() {
        
        manager.getAllSmartThing { [weak self] items in
            
            guard let values = items else {
                DispatchQueue.main.async {
                    self?.loadingStatus = .error
                }
                return
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self?.devices = values.data
                    self?.loadingStatus = .loaded
                }
                self?.saveDevicesToCache(values.data, withName: self?.nameCache ?? "devices")
            }
            
        } errorCallback: { error in
            DispatchQueue.main.async {
                withAnimation {
                    self.loadingStatus = .error
                }
            }
        }
    }
    
    
    private func saveDevicesToCache(_ devices: [Device?], withName name: String) {
        
        if let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = cacheDirectory.appendingPathComponent(name)
            
            do {
                let data = try JSONEncoder().encode(devices)
                
                try data.write(to: fileURL)
                print("Массив объектов сохранен в кеше: \(fileURL)")
            } catch {
                print("Ошибка при сохранении массива объектов: \(error)")
            }
        }
    }
    
    
    func removeDeviceFromCache(id: Int) {
        
        guard let index = self.devices.firstIndex(where: { $0?.id == id }) else { return }
        DispatchQueue.main.async {
            self.devices.remove(at: index)
            self.saveDevicesToCache(self.devices, withName: self.nameCache)
            self.showAlert = false
        }
    }
    
    func dateFormatting(_ date: Date?) -> String {
        
        var formattedDate = String()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let workTime = date {
            formattedDate = dateFormatter.string(from: workTime)
        }
        return formattedDate
    }
}

