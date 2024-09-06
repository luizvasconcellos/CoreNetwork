//
//  SaveStringAPIService.swift
//  
//
//  Created by Luiz Vasconcellos on 03/09/24.
//

import Foundation

/// A class with the Service for Save String, to perform the API request
public class SaveStringAPIService {
    private let networkManager: NetworkManagerProtocol
    private let baseUrl = "https://us-central1-mobilesdklogging.cloudfunctions.net/"
    
    private enum SaveStringAPIEndPoint: String {
        case saveString
    }
    
    /// SaveStringAPIService initializer
    /// - Parameter networkManager: NetworkManagerProtocol instance to be used to perform the request.
    public init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    /// A function which call the save string API and handle the errors.
    /// - Parameter string: the string to be saved.
    /// - Returns: A Result with the string if the string was succsessfully saved and custom `NetworkAPIError` property handled if we got an error.
    public func saveString(_ string: String) async -> Result<String, NetworkAPIError> {
        let urlString = "\(baseUrl)\(SaveStringAPIEndPoint.saveString.rawValue)"
        guard let url = URL(string: urlString) else { return .failure(.invalidUrl) }
        
        let json: [String: String] = ["myString": string]
        
        do {
            let jsonBodyData = try? JSONSerialization.data(withJSONObject: json)
            
            let request = NetworkRequest(baseURL: url,
                                         method: .post,
                                         bodyParameters: jsonBodyData)
            
            let result = try await networkManager.baseRequest(request: request, type: String.self)
            
            switch result {
            case .success(let resultMessage):
                print("DEBUG:: CoreNetworking - Result Message: \(resultMessage)")
                return .success(resultMessage)
            case .failure(let error):
                print("DEBUG:: CoreNetworking - Error: \(error)")
                return .failure(error)
            }
        } catch {
            print("DEBUG:: CoreNetworking - Unknown error: \(error.localizedDescription)")
            return .failure(.unknownError(error: error))
        }
    }
}
