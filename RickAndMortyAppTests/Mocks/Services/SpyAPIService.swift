//
//  SpyAPIService.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import Foundation
@testable import RickAndMortyApp

final class SpyApiService: APIServiceProtocol {
    
    // Flags para controlar o comportamento do mock
    var shouldReturnError = false
    var errorToReturn: NetworkError = .requestFailed
    var delayInSeconds: Double = 0
    
    // Contadores para verificiar quantas vezes os métodos foram chamados
    var fetchCharactersCallCount = 0
    var fetchLocationCallCount = 0
    var fetchEpisodesCallCount = 0
    var searchCharactersCallCount = 0
    
    // Amarzena parâmetros recebidos para validação
    var lastPageRequested: Int?
    
    // Dados que serão retornados pelos métodos mock
    var mockCharacterResponse: CharacterResponse = TestData.mockCharacterResponse
    var mockLocationResponse: LocationResponse = TestData.mockLocationResponse
    var mockEpisodeResponse: EpisodeResponse = TestData.mockEpisodeResponse
    
    func fetchCharacters(page: Int) async throws -> RickAndMortyApp.CharacterResponse {
        fetchCharactersCallCount += 1
        lastPageRequested = page
        
        if delayInSeconds > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw errorToReturn
        }
        
        if page > 1 {
            return CharacterResponse(info: Info(count: 826,
                                                pages: 42,
                                                next: page < 42 ? "https://rickandmortyapi.com/api/character?page=\(page + 1)" : nil,
                                                previous: "https://rickandmortyapi.com/api/character?page=\(page - 1)"),
                                     results: TestData.mockCharacters)
        }
        return mockCharacterResponse
    }
    
    func fetchLocations(page: Int) async throws -> RickAndMortyApp.LocationResponse {
        fetchLocationCallCount += 1
        lastPageRequested = page
        
        if delayInSeconds > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw errorToReturn
        }
        
        return mockLocationResponse
    }
    
    func fetchEpisodes(page: Int) async throws -> RickAndMortyApp.EpisodeResponse {
        fetchEpisodesCallCount += 1
        lastPageRequested = page
        
        if delayInSeconds > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw errorToReturn
        }
        
        return mockEpisodeResponse
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = .requestFailed
        delayInSeconds = 0
        fetchCharactersCallCount = 0
        fetchLocationCallCount = 0
        fetchEpisodesCallCount = 0
        searchCharactersCallCount = 0
        lastPageRequested = nil
        mockCharacterResponse = TestData.mockCharacterResponse
        mockLocationResponse = TestData.mockLocationResponse
        mockEpisodeResponse = TestData.mockEpisodeResponse
    }
}
