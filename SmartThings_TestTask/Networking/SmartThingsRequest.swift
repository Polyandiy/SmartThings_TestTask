//
//  Network.swift
//  ListOfSmartThings_TestTask
//
//  Created by Поляндий on 27.10.2023.
//

import Foundation

typealias ErrorCallback = (Error?) -> Void
typealias SuccessCallback = (Devices?) -> Void
enum DataParsingError: Error {
    case invalidFormat
    case missingData
}

final class SmartThingsRequest: NSObject {
    
    func getAllSmartThing(success: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {

        guard let url = URL(string: "https://api.fasthome.io/api/v1/test/devices") else { return } 

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                errorCallback(error)
                return
            }

            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let response = try decoder.decode(Devices.self, from: data)
                    success(response)
                } catch {
                    errorCallback(DataParsingError.invalidFormat)
                }
            } else {
                errorCallback(DataParsingError.missingData)
            }
        }
        task.resume()
    }
    

}


