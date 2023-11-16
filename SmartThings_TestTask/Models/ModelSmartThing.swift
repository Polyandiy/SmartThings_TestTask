//
//  ModelSmartThing.swift
//  ListOfSmartThings_TestTask
//
//  Created by Поляндий on 27.10.2023.
//

import Foundation

struct Devices: Codable {
    let data: [Device?]
}

struct Device: Codable, Hashable {
    let id: Int?
    let name: String?
    let icon: String?
    let isOnline: Bool?
    let status: String?
    let lastWorkTime: Date?
}

enum LoadingStatus {
    case loading
    case loaded
    case error
}
