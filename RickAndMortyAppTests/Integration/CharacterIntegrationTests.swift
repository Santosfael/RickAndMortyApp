//
//  CharacterIntegrationTests.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 11/01/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class CharacterIntegrationTests: XCTestCase {
    var mockAPIService: SpyApiService!
    var viewModel: HomeCharacterListViewModel!

    override func setUp() {
        super.setUp()
        mockAPIService = SpyApiService()
        viewModel = HomeCharacterListViewModel(apiService: mockAPIService)
    }

    override func tearDown() {
        mockAPIService = nil
        viewModel = nil
        super.tearDown()
    }

    // Testa o fluxo COMPLETO: ViewModel → Service → Resposta
    // Verifica se dados são carregados corretamente
    func testFetchCharacterIntegration_Success() async throws {
        // ARRANGE (Preparação)
        // Estado inicial: nenhum personagem carregado
        XCTAssertTrue(viewModel.characters.isEmpty, "Characters should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")

        // ACT (Ação)
        // Executa a busca de personagens
        await viewModel.fetchCharacters()

        // ASSERT (Verificação)
        // Verifica se dados foram carregados corretamente
        XCTAssertFalse(viewModel.characters.isEmpty, "Characters should be loaded")
        XCTAssertEqual(viewModel.characters.count, 3, "Should have 3 characters")
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez", "First character should be Rick")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
        XCTAssertNil(viewModel.errorMessage, "Should have no error")
        XCTAssertEqual(viewModel.currentPage, 1, "Current page should be 1")
        XCTAssertTrue(viewModel.hasMorePages, "Should have more pages")
        
        // Verifica se o service foi chamado corretamente
        XCTAssertEqual(mockAPIService.fetchCharactersCallCount, 1, "API should be called once")
        XCTAssertEqual(mockAPIService.lastPageRequested, 1, "Should request page 1")
    }

    // Testa cenário de ERRO na requisição
    // Verifica se erro é tratado corretamente
    func testFetchCharactersIntegration_Failure() async throws {
        // ARRANGE
        mockAPIService.shouldReturnError = true
        mockAPIService.errorToReturn = .requestFailed

        // ACT
        await viewModel.fetchCharacters()

        // ASSERT
        XCTAssertTrue(viewModel.characters.isEmpty, "Characters should be empty on error")
        XCTAssertNotNil(viewModel.errorMessage, "Should have error message")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after error")
        XCTAssertEqual(mockAPIService.fetchCharactersCallCount, 1, "API should be called once")
    }

    // Testa PAGINAÇÃO: carregar mais personagens
    // Verifica se lista é incrementada corretamente
    func testLoadMoreCharactersIntegration_Success() async throws {
        // ARRANGE
        // Primeiro, carrega página 1
        await viewModel.fetchCharacters()
        let initialCount = viewModel.characters.count
        XCTAssertEqual(initialCount, 3, "Should have 3 characters initially")
        
        // ACT
        // Carrega página 2
        await viewModel.loadModeCharacters()
        
        // ASSERT
        XCTAssertEqual(viewModel.characters.count, initialCount + 3, "Should have 6 characters total")
        XCTAssertEqual(viewModel.currentPage, 2, "Current page should be 2")
        XCTAssertEqual(mockAPIService.fetchCharactersCallCount, 2, "API should be called twice")
        XCTAssertEqual(mockAPIService.lastPageRequested, 2, "Should request page 2")
    }

    // Testa REFRESH (pull to refresh)
    // Verifica se dados são recarregados do zero
    func testRefreshCharactersIntegration() async throws {
        // ARRANGE
        // Carrega algumas páginas
        await viewModel.fetchCharacters()
        await viewModel.loadModeCharacters()
        XCTAssertEqual(viewModel.currentPage, 2, "Should be on page 2")
        
        // ACT
        // Faz refresh
        await viewModel.refreshCharacters()
        
        // ASSERT
        XCTAssertEqual(viewModel.currentPage, 1, "Should reset to page 1")
        XCTAssertEqual(viewModel.characters.count, 3, "Should have only page 1 data")
        XCTAssertEqual(mockAPIService.fetchCharactersCallCount, 3, "API should be called 3 times total")
    }

    // Testa ESTADO DE LOADING
    // Verifica se flag isLoading muda corretamente
    func testLoadingStateTransitions() async throws {
        // ARRANGE
        mockAPIService.delayInSeconds = 0.1  // Simula latência
        
        // ACT & ASSERT
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")
        
        // Inicia fetch em background
        let task = Task {
            await viewModel.fetchCharacters()
        }
        
        // Aguarda um pouco e verifica loading
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05 segundos
        XCTAssertTrue(viewModel.isLoading, "Should be loading during request")
        
        // Aguarda conclusão
        await task.value
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    }

    // Testa LIMITE DE PAGINAÇÃO
    // Verifica se para de carregar quando não há mais páginas
    func testLoadMoreWhenNoMorePages() async throws {
        // ARRANGE
        await viewModel.fetchCharacters()
        viewModel.hasMorePages = false  // Simula última página
        let countBeforeLoad = viewModel.characters.count
        
        // ACT
        await viewModel.loadModeCharacters()
        
        // ASSERT
        XCTAssertEqual(viewModel.characters.count, countBeforeLoad, "Should not load more when no more pages")
        XCTAssertEqual(mockAPIService.fetchCharactersCallCount, 1, "API should not be called again")
    }

    // Testa MÚLTIPLAS CHAMADAS SIMULTÂNEAS
    // Verifica se previne requisições duplicadas
    func testMultipleSimultaneousLoadMoreRequests() async throws {
        // ARRANGE
        await viewModel.fetchCharacters()
        mockAPIService.delayInSeconds = 0.2  // Simula requisição lenta
        
        // ACT
        // Dispara múltiplas requisições ao mesmo tempo
        async let load1: () = viewModel.loadModeCharacters()
        async let load2: () = viewModel.loadModeCharacters()
        async let load3: () = viewModel.loadModeCharacters()
        
        await load1
        await load2
        await load3
        
        // ASSERT
        // Deve processar apenas UMA requisição por vez
        XCTAssertEqual(mockAPIService.fetchCharactersCallCount, 2, "Should only call API twice (initial + one loadMore)")
    }

    // Testa DADOS VAZIOS
    // Verifica comportamento quando API retorna lista vazia
    func testEmptyResponseHandling() async throws {
        // ARRANGE
        mockAPIService.mockCharacterResponse = TestData.emptyCharacterResponse
        
        // ACT
        await viewModel.fetchCharacters()
        
        // ASSERT
        XCTAssertTrue(viewModel.characters.isEmpty, "Characters should be empty")
        XCTAssertNil(viewModel.errorMessage, "Should not have error for empty response")
        XCTAssertFalse(viewModel.hasMorePages, "Should not have more pages")
    }
}
