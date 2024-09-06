//
//  SaveStringAPIServiceTests.swift
//  CoreNetworkTests
//
//  Created by Luiz Vasconcellos on 06/09/24.
//

import XCTest
@testable import CoreNetwork

final class SaveStringAPIServiceTests: XCTestCase {
    func testSaveStringSuccess() async {
        let networkManager = MockNetworkManager()
        networkManager.result = .success("String armazenada com sucesso. ID do documento: A54u0sIhHTG2m2T9JXIZ")
        
        let service = SaveStringAPIService(networkManager: networkManager)
        let result = await service.saveString("Teste")
        
        switch result {
        case .success(let message):
            XCTAssertEqual(message, "String armazenada com sucesso. ID do documento: A54u0sIhHTG2m2T9JXIZ")
        case .failure:
            XCTFail("It was expected success but got failure.")
        }
    }
    
    func testSaveStringErrorInvalidURL() async {
        let networkManager = MockNetworkManager()
        networkManager.result = .failure(.invalidUrl)
        
        let service = SaveStringAPIService(networkManager: networkManager)
        let result = await service.saveString("Teste")
        
        switch result {
        case .success:
            XCTFail("It was expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidUrl)
        }
    }
    
    func testSaveStringErrorInvalidResponse() async {
        let networkManager = MockNetworkManager()
        networkManager.result = .failure(.invalidResponse)
        
        let service = SaveStringAPIService(networkManager: networkManager)
        let result = await service.saveString("Teste")
        
        switch result {
        case .success:
            XCTFail("It was expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidResponse)
        }
    }
    
    func testSaveStringErrorInvalidStatusCode() async {
        let networkManager = MockNetworkManager()
        networkManager.result = .failure(.invalidStatusCode(statusCode: 405))
        
        let service = SaveStringAPIService(networkManager: networkManager)
        let result = await service.saveString("Teste")
        
        switch result {
        case .success:
            XCTFail("It was expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidStatusCode(statusCode: 405))
        }
    }
    
    func testSaveStringErrorJsonParse() async {
        let networkManager = MockNetworkManager()
        networkManager.result = .failure(.jsonParsingFailure)
        
        let service = SaveStringAPIService(networkManager: networkManager)
        let result = await service.saveString("Teste")
        
        switch result {
        case .success:
            XCTFail("It was expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .jsonParsingFailure)
        }
    }
    
    func testSaveStringErrorRequestFailed() async {
        let networkManager = MockNetworkManager()
        networkManager.result = .failure(.requestFailed(description: "fail"))
        
        let service = SaveStringAPIService(networkManager: networkManager)
        let result = await service.saveString("Teste")
        
        switch result {
        case .success:
            XCTFail("It was expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .requestFailed(description: "fail"))
        }
    }
    
    func testSaveStringErrorGenericUnknownError() async {
        let networkManager = MockNetworkManager()
        networkManager.result = .failure(.unkownGenericError(description: "failed"))
        
        let service = SaveStringAPIService(networkManager: networkManager)
        let result = await service.saveString("Teste")
        
        switch result {
        case .success:
            XCTFail("It was expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .unkownGenericError(description: "failed"))
        }
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    var result: Result<String, NetworkAPIError>!
    
    func baseRequest<T>(request: NetworkRequest, type: T.Type) async throws -> Result<T, NetworkAPIError> where T : Decodable {
        return result as! Result<T, NetworkAPIError>
    }
}
