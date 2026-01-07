//
//  MockCharacterServiceFailure.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

@testable import RickAndMortyApp

final class MockCharacterServiceFailure: APIServiceProtocol {
    func fetchCharacters(page: Int) async throws -> RickAndMortyApp.CharacterResponse {
        throw NetworkError.requestFailed
    }

    func fetchLocations(page: Int) async throws -> RickAndMortyApp.LocationResponse {
        return LocationResponse(info: Info(count: 0, pages: 0, next: "", previous: ""), results: [])
    }

    func fetchEpisodes(page: Int) async throws -> RickAndMortyApp.EpisodeResponse {
        return EpisodeResponse(info: Info(count: 0, pages: 0, next: "", previous: ""), results: [])
    }
}
