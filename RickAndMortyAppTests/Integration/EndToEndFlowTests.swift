//
//  EndToEndFlowTests.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 12/01/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class EndToEndFlowTests: XCTestCase {

    var spyAPIService: SpyApiService!
    var characterViewModel: HomeCharacterListViewModel!
    var locationViewModel: LocationListViewModel!
    var episodeViewModel: EpisodeListViewModel!

    override func setUp() {
        super.setUp()
        spyAPIService = SpyApiService()
        characterViewModel = HomeCharacterListViewModel(apiService: spyAPIService)
        locationViewModel = LocationListViewModel(apiService: spyAPIService)
        episodeViewModel = EpisodeListViewModel(apiService: spyAPIService)
    }

    override func tearDown() {
        spyAPIService = nil
        characterViewModel = nil
        locationViewModel = nil
        episodeViewModel = nil
        super.tearDown()
    }

    // Simular usuário navegando por todas as abas
    // Verifica se dados são corregados em cada aba
    func testCompleteUserFlow_NavigateThroughAllTabs() async throws {
        // Simula abertura do app e carregamento da aba Characters
        await characterViewModel.fetchCharacters()
        XCTAssertFalse(characterViewModel.characters.isEmpty, "Characters should load")
        
        // Simula navegação para aba location
        await locationViewModel.fetchLocations()
        XCTAssertFalse(locationViewModel.locations.isEmpty, "Locations should load")

        // Simula navegação para aba episodes
        await episodeViewModel.fetchEpisodes()
        XCTAssertFalse(episodeViewModel.episodes.isEmpty, "Episodes should load")
        
        // Verifica quetodos os services foram chamados
        XCTAssertEqual(spyAPIService.fetchCharactersCallCount, 1)
        XCTAssertEqual(spyAPIService.fetchLocationCallCount, 1)
        XCTAssertEqual(spyAPIService.fetchEpisodesCallCount, 1)
    }

    // Simula o usuário fazendo scrol até o final
    // em múltiplas abas
    func testCompleteUserFlow_PaginationAcrossMultiplesTabs() async throws {
        // Characters: carrega a página 1 e 2
        await characterViewModel.fetchCharacters()
        await characterViewModel.loadModeCharacters()
        XCTAssertEqual(characterViewModel.currentPage, 2)
        
        // Location: carrega a página 1 e 2
        await locationViewModel.fetchLocations()
        await locationViewModel.loadMoreLocations()
        XCTAssertEqual(locationViewModel.currentPage, 2)

        // Episodes: carrega a página 1 e 2
        await episodeViewModel.fetchEpisodes()
        await episodeViewModel.loadMoreEpisodes()
        XCTAssertEqual(episodeViewModel.currentPage, 2)
        
        // Verifica quetodos os services foram chamados
        XCTAssertEqual(spyAPIService.fetchCharactersCallCount, 2)
        XCTAssertEqual(spyAPIService.fetchLocationCallCount, 2)
        XCTAssertEqual(spyAPIService.fetchEpisodesCallCount, 2)
    }

    // Simula o usuário fazendo pull-to-refresh em todas as abas
    func testCompleteUserFlow_RefreshAllTabs() async throws {
        // ARRANGE
        await characterViewModel.fetchCharacters()
        await locationViewModel.fetchLocations()
        await episodeViewModel.fetchEpisodes()

        // ACT
        await characterViewModel.refreshCharacters()
        await locationViewModel.refreshLocations()
        await episodeViewModel.refreshLocations()
        
        // ASSERT
        XCTAssertEqual(characterViewModel.currentPage, 1)
        XCTAssertEqual(locationViewModel.currentPage, 1)
        XCTAssertEqual(episodeViewModel.currentPage, 1)
        
        XCTAssertEqual(spyAPIService.fetchCharactersCallCount, 2)
        XCTAssertEqual(spyAPIService.fetchLocationCallCount, 2)
        XCTAssertEqual(spyAPIService.fetchEpisodesCallCount, 2)
    }

    // Simular cenário de erro seguido de recuperação
    func testCompleteUserFlow_ErrorRecovery() async throws {
        // Simular erro de rede
        spyAPIService.shouldReturnError = true
        await characterViewModel.fetchCharacters()
        XCTAssertNotNil(characterViewModel.errorMessage)
        XCTAssertTrue(characterViewModel.characters.isEmpty)
        
        // Usuário tenta novamente (rede volta)
        spyAPIService.shouldReturnError = false
        await characterViewModel.refreshCharacters()
        XCTAssertNil(characterViewModel.errorMessage)
        XCTAssertFalse(characterViewModel.characters.isEmpty)
    }

    func testCompleteUserFlow_MultipleAppSessions() async throws {
        // Sessão 1: usuário abre app, vê characters, fecha
        await characterViewModel.fetchCharacters()
        let session1Count = characterViewModel.characters.count
        
        // Sessão 2: usuário abre o app novamente, refresh automático
        await characterViewModel.refreshCharacters()
        XCTAssertEqual(characterViewModel.characters.count, session1Count)
        
        // Sessão 3: usuário explora locations
        await locationViewModel.fetchLocations()
        XCTAssertFalse(locationViewModel.locations.isEmpty)
    }
}
