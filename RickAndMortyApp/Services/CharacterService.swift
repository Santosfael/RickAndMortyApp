//
//  CharacterService.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import Foundation

protocol CharacterServiceProtocol {
    func fetchCharacters(page: Int) async throws -> CharacterResponse
}

class CharacterService: CharacterServiceProtocol {
    static let shared = CharacterService()

    private let baseURL = "https://rickandmortyapi.com/api/character"
    func fetchCharacters(page: Int) async throws -> CharacterResponse {
        guard let url = URL(string: "\(baseURL)?page=\(page)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
