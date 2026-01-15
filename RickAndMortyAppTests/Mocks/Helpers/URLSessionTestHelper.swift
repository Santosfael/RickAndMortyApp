//
//  URLSessionTestHelper.swift
//  RickAndMortyApp
//
//  Created by Rafael on 14/01/26.
//

import Foundation

/*
 ** Helper que cria URLSession configurado para usar o MockURLProtocol
 ** Simplifica a configuração dos testes
 */
struct URLSessionTestHelper {
    
    //Cria uma URLSession que usa o MockURLProtocol ao invés de fazer requisições reais
    static func createMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
    
    // Tem como objetivo criar um HTTPURLResponse fake para os testes
    static func createHTTPResponse(
        url: URL,
        statusCode: Int = 200,
        headers: [String: String]? = nil
    ) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headers
        )!
    }
    
    // Cria um NSError fake para simular os erros de rede
    static func createNetworkError(code: Int = NSURLErrorNotConnectedToInternet) -> NSError {
        return NSError(
            domain: NSURLErrorDomain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
    }
}
