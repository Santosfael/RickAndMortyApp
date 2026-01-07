//
//  MockCharacterServiceDelayed.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

@testable import RickAndMortyApp

final class MockCharacterServiceDelayed: APIServiceProtocol {
    func fetchCharacters(page: Int) async throws -> RickAndMortyApp.CharacterResponse {
        try await Task.sleep(nanoseconds: 300_000_000)
        return CharacterResponse(info: Info(count: 0, pages: 0, next: "", previous: ""),
                                 results: [Character(id: 361,
                                                      name: "Toxic Rick",
                                                      status: "Dead",
                                                      species: "Homanoid",
                                                      type: "Rick's Toxic Side",
                                                      gender: "Male",
                                                      origin: Origin(name: "Alien Spa",
                                                                     url: "https://rickandmortyapi.com/api/location/64"),
                                                      location: Location(name: "Earth",
                                                                         url: "https://rickandmortyapi.com/api/location/20"),
                                                      image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
                                                      episode: ["https://rickandmortyapi.com/api/episode/27"],
                                                      url: "https://rickandmortyapi.com/api/character/361",
                                                      created: "2018-01-10T18:20:41.703Z")
        ])
    }

    func fetchLocations(page: Int) async throws -> RickAndMortyApp.LocationResponse {
        return LocationResponse(info: Info(count: 0, pages: 0, next: "", previous: ""), results: [])
    }

    func fetchEpisodes(page: Int) async throws -> RickAndMortyApp.EpisodeResponse {
        return EpisodeResponse(info: Info(count: 0, pages: 0, next: "", previous: ""), results: [])
    }
}
