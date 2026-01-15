//
//  MockURLProtocol.swift
//  RickAndMortyApp
//
//  Created by Rafael on 14/01/26.
//

import Foundation

/*
 ** MockURLProtocol intercepta as requisições HTTP do URLSession
 ** Permitindo retorna resposta fake sem fazer requisições reais
 ** Sendo assim o coração dos testes unitários de networking
 */
class MockURLProtocol: URLProtocol {
    
    // MARK: - Static Properties para Configuração
    
    /*
     ** É uma closure que será executada quando o URLSession fizer requisição
     ** Returna uma tupla (data, response, error) simulando assim uma resposta real
     */
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    // Armazena a última requisição feita(É útil para validações)
    static var lastRequest: URLRequest?
    
    enum MockError: Error {
        case handlerNotSet
    }
    
    // MARK: - URLProtocol Override Methods
    
    /*
     ** O canInit determina se esse protocol pode lidas com a requisição
     ** Onde setamos que iremos retornar sempre true(verdadeiro) para todas as requisições
     */
    override class func canInit(with request: URLRequest) -> Bool {
        lastRequest = request
        return true
    }
    
    // O canonicalRequest returna a requisição sem modificações
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    
    /*
     ** No startLoading é onde a mágica acontece
     ** É aqui que retornamos a resposta fake configurada no requestHandler
     */
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: MockError.handlerNotSet)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        do {
            // Executa o handler para obter a resposta fake
            let (response, data) = try handler(request)
            
            // Notifica o client (URLSession) da resposta
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            // Se há dados, envia para o client
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            // Tem como objetivo finalizar a requisição
            client?.urlProtocolDidFinishLoading(self)
        }
        catch {
            // Em caso de erro, notifica o client
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
    
    static func reset() {
        requestHandler = nil
        lastRequest = nil
    }
}
