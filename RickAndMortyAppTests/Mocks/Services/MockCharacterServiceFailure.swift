//
//  MockCharacterServiceFailure.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

@testable import RickAndMortyApp

final class MockApiServiceFailure: APIServiceProtocol {
    func fetchCharacters(page: Int) async throws -> RickAndMortyApp.CharacterResponse {
        throw NetworkError.requestFailed
    }

    func fetchLocations(page: Int) async throws -> RickAndMortyApp.LocationResponse {
        throw NetworkError.requestFailed
    }

    func fetchEpisodes(page: Int) async throws -> RickAndMortyApp.EpisodeResponse {
        throw NetworkError.requestFailed
    }
}
