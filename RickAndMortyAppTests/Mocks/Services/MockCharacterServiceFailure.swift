//
//  MockCharacterServiceFailure.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

@testable import RickAndMortyApp

final class MockCharacterServiceFailure: CharacterServiceProtocol {
    func fetchCharacters(page: Int) async throws -> RickAndMortyApp.CharacterResponse {
        throw NetworkError.requestFailed
    }
}
