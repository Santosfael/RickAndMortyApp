//
//  APIServiceTests.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 14/01/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var mockURLSession: URLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = URLSessionTestHelper.createMockSession()
        
        apiService = APIService(urlSession: mockURLSession)
        
        MockURLProtocol.reset()
    }

    override func tearDown() {
        apiService = nil
        mockURLSession = nil
        MockURLProtocol.reset()
        super.tearDown()
    }

    // MARK: - fetchCharacters Tests
    /*
     ** Tem como objetivo buscar os personagem com sucesso
     ** Verifica se fetchCharacters retorna dados corretos quando
     ** a api retorna status 200 e um JSON válido
     */
    func testFetchCharacters_Success_ReturnsCharacterResponse() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/character?page=1")!
        let mockData = try JSONEncoder().encode(TestData.mockCharacterResponse)
        
        // Configura MockURLProtocol para retornar resposta fake
        MockURLProtocol.requestHandler = { request in
            // Valida que a URL está correta
            XCTAssertEqual(request.url, expectedURL)
            XCTAssertEqual(request.httpMethod, "GET")
            
            // Retorna uma resposta simulada
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
            
            return (response, mockData)
        }
        
        // ACT
        let result = try await apiService.fetchCharacters(page: 1)
        
        // ASSERT
        XCTAssertEqual(result.results.count, TestData.mockCharacters.count)
        XCTAssertEqual(result.results.first?.name, "Rick Sanchez")
        XCTAssertEqual(result.info.count, 826)
        XCTAssertNotNil(result.info.next)
    }

    /*
     ** Tem como objetivo verificar se a url está fazia
     ** Verifica se fetchCharacters irá lançar o NetworkError.invalidURL
     */
    func testFetchCharacters_InvalidURL_ThrowInvalideURLError() async throws {
        // ARRANGE
        apiService = APIService(urlSession: mockURLSession, baseURL: "")
        
        // ACT E ASSERTS
        do {
            _ = try await apiService.fetchCharacters(page: 1)
            XCTFail("Should have thrown NetworkError.invalidURL")
        } catch {
            // Válida se o erro lançado é esperado
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }

    /*
     ** Tem como objetivo verificar erro de requisição statuscode != 200
     ** Verifica se fetchCharacters irá lançar o NetworkError.requestFailed
     ** quando a API retorna status diferente de 200
     */
    func testFetchCharacters_Non200StatusCode_ThrowsRequestFailedError() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/character?page=1")!
        
        MockURLProtocol.requestHandler = { request in
            // Retorna status 404 (Not found)
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 404)
            
            return (response, nil)
        }
        
        // ACT E ASSERTS
        do {
            _ = try await apiService.fetchCharacters(page: 1)
            XCTFail("Should have thrown NetworkError.requestFailed")
        } catch {
            // Válida se o erro lançado é esperado
            XCTAssertEqual(error as? NetworkError, NetworkError.requestFailed)
        }
    }

    /*
     ** Tem como objetivo verificar a decodificação do JSON
     ** Verifica se fetchCharacters irá lançar o NetworkError.decodingFailed
     ** quando a API retorna JSON mal formatado
     */
    func testFetchCharacters_InvalidJSON_ThrowsDecodingFailedError() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/character?page=1")!
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
            
            return (response, invalidJSON)
        }
        
        // ACT E ASSERT
        do {
            _ = try await apiService.fetchCharacters(page: 1)
            XCTFail("Should have thrown NetworkError.decodingFailed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.decodingFailed)
        }
    }

    /*
     ** Tem como objetivo verificar erro de rede
     ** Verifica se fetchCharacters propaga erros de rede
     */
    func testFetchCharacters_NetworkError_ThrowsError() async throws {
        // ARRANGE
        let networkError = URLSessionTestHelper.createNetworkError()
        
        MockURLProtocol.requestHandler = { request in
            throw networkError
        }
        
        // ACT ASSERTS
        do {
            _ = try await apiService.fetchCharacters(page: 1)
            XCTFail("Should have thrown Network Error")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    /*
     ** Tem como objetivo verificar a construção correta da URL com diferentes páginas
     ** Verifica se o parâmetro de página é incluído corratamente na url
     */
    func testFetchCharacters_DifferentPages_BuildsCorrectURL() async throws {
        // ARRANGE
        let pages = [1, 2, 5, 10]
        
        for page in pages {
            let expectedURL = URL(string: "\(ConfigManager.baseURL)/character?page=\(page)")!
            let mockData = try JSONEncoder().encode(TestData.mockCharacterResponse)
            
            MockURLProtocol.requestHandler = { request in
                // Valida que a URL está correta
                XCTAssertEqual(request.url, expectedURL)
                XCTAssertEqual(request.httpMethod, "GET")
                
                // Retorna uma resposta simulada
                let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
                
                return (response, mockData)
            }
            
            // ACT ASSERTS
            _ = try await apiService.fetchCharacters(page: page)
        }
    }

    // MARK: - fetchLocations Tests

    /*
     ** Tem como objetivo verificar se a ultima requisição foi armazenada
     ** assim validando que o MockURLProtocol está armazenando as requisições
     */
    func testFetchCharacters_StoresLastRequest() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/character?page=1")!
        let mockData = try JSONEncoder().encode(TestData.mockCharacterResponse)
        
        MockURLProtocol.requestHandler = { request in
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
            
            return (response, mockData)
        }
        
        // ACT
        _ = try await apiService.fetchCharacters(page: 1)
        
        // ASSERTS
        XCTAssertNotNil(MockURLProtocol.lastRequest)
        XCTAssertEqual(MockURLProtocol.lastRequest?.url, expectedURL)
    }

    /*
     ** Tem como objetivo buscar as localizações com sucesso
     ** Verifica se fetchLocations retorna dados corretos quando
     ** a api retorna status 200 e um JSON válido
     */
    func testFetchLocations_Success_ReturnsLocationsResponse() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/location?page=1")!
        let mockData = try JSONEncoder().encode(TestData.mockLocationResponse)
        
        // Configura MockURLProtocol para retornar resposta fake
        MockURLProtocol.requestHandler = { request in
            // Valida que a URL está correta
            XCTAssertEqual(request.url, expectedURL)
            XCTAssertEqual(request.httpMethod, "GET")
            
            // Retorna uma resposta simulada
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
            
            return (response, mockData)
        }
        
        // ACT
        let result = try await apiService.fetchLocations(page: 1)
        
        // ASSERT
        XCTAssertEqual(result.results.count, TestData.mockLocations.count)
        XCTAssertEqual(result.results.first?.name, "Earth (C-137)")
        XCTAssertEqual(result.results.first?.type, "Planet")
    }

    /*
     ** Tem como objetivo verificar se a url está fazia
     ** Verifica se fetchCharacters irá lançar o NetworkError.invalidURL
     */
    func testFetchLocations_InvalidURL_ThrowInvalideURLError() async throws {
        // ARRANGE
        apiService = APIService(urlSession: mockURLSession, baseURL: "")
        
        // ACT E ASSERTS
        do {
            _ = try await apiService.fetchLocations(page: 1)
            XCTFail("Should have thrown NetworkError.invalidURL")
        } catch {
            // Válida se o erro lançado é esperado
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }

    /*
     ** Tem como objetivo verificar erro de requisição statuscode != 200
     ** Verifica se irá retornar o tratamento de erro do servidor
     */
    func testFetchLocations_ServerError_ThrowsRequestFailedError() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/location?page=1")!
        MockURLProtocol.requestHandler = { request in
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 500)
            
            return (response, nil)
        }
        
        //ACT & ASSERT
        do {
            _ = try await apiService.fetchLocations(page: 1)
            XCTFail("Should have thrown NetworkError.requestFailed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.requestFailed)
        }
    }

    /*
     ** Tem como objetivo testar se o JSON está incompleto
     ** Verifica e lança o erro de decodificação com dados incompletos
     */
    func testFetchLocations_ImcompleteJSON_ThrowsDecodingFailedError() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/location?page=1")!
        let incompleteJSON = """
            {
                "info": {
                    "count": 126
                }
            }
            """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
            
            return (response, incompleteJSON)
        }
        
        // ACT & ASSERTS
        do {
            _ = try await apiService.fetchLocations(page: 1)
            XCTFail("Should have thrown NetworkError.decodingFailed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.decodingFailed)
        }
    }

    // MARK: - fetchEpisodes Tests

    /*
     ** Tem como objetivo validar se a busca por episódios foi um sucesso
     ** Verifica se o fetchEpisodes retorna os dados corretos
     */
    func testFetchEpisodes_Success_ReturnsEpisodesResponse() async throws {
        //ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/episode?page=1")!
        let mockData = try JSONEncoder().encode(TestData.mockEpisodeResponse)
        MockURLProtocol.requestHandler = { request in
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
            
            return (response, mockData)
        }

        // ACT
        let result = try await apiService.fetchEpisodes(page: 1)

        // ASSERTS
        XCTAssertEqual(result.results.count, TestData.mockEpisodes.count)
        XCTAssertEqual(result.results.first?.name, "Pilot")
        XCTAssertEqual(result.results.first?.episode, "S01E01")
    }

    /*
     ** Tem como objetivo verificar erro de requisição statuscode != 200
     ** Verifica se irá retornar o tratamento de erro do servidor
     */
    func testFetchEpisodes_ServerError_ThrowsRequestFailedError() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/episode?page=1")!
        MockURLProtocol.requestHandler = { request in
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 500)
            
            return (response, nil)
        }
        
        //ACT & ASSERT
        do {
            _ = try await apiService.fetchEpisodes(page: 1)
            XCTFail("Should have thrown NetworkError.requestFailed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.requestFailed)
        }
    }

    /*
     ** Tem como objetivo validar se os dados estão vazios
     ** Verifica o comportamento da API quando retorna dados fazios.
     */
    func testFetchEpisodes_EmptyData_ThrowsDecodingFailedError() async throws {
        // ARRANGE
        let expectedURL = URL(string: "\(ConfigManager.baseURL)/episode?page=1")!
        let emptyData = Data()
        
        MockURLProtocol.requestHandler = { request in
            let response = URLSessionTestHelper.createHTTPResponse(url: expectedURL, statusCode: 200)
            
            return (response, emptyData)
        }

        // ACT & ASSERT
        do {
            _ = try await apiService.fetchEpisodes(page: 1)
            XCTFail("Should have thrown NetworkError.decodingFailed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.decodingFailed)
        }
    }
}
