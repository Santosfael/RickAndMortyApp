//
//  APIService.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCharacters(page: Int) async throws -> CharacterResponse
    func fetchLocations(page: Int) async throws -> LocationResponse
    func fetchEpisodes(page: Int) async throws -> EpisodeResponse
}

class APIService: APIServiceProtocol {
    private let baseURL = ConfigManager.baseURL

    init(){}

    func fetchCharacters(page: Int) async throws -> CharacterResponse {
        guard let url = URL(string: "\(baseURL)/character?page=\(page)") else {
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
    
    func fetchLocations(page: Int) async throws -> LocationResponse {
        guard let url = URL(string: "\(baseURL)/location?page=\(page)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    func fetchEpisodes(page: Int) async throws -> EpisodeResponse {
        guard let url = URL(string: "\(baseURL)/episode?page\(page)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(EpisodeResponse.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
