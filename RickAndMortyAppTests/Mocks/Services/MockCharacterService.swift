//
//  MockCharacterService.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

@testable import RickAndMortyApp

final class MockApiService: APIServiceProtocol {
    func fetchCharacters(page: Int) async throws -> RickAndMortyApp.CharacterResponse {
        return CharacterResponse(info: Info(count: 0, pages: 0, next: "", previous: ""), results: [
            Character(id: 361,
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
        return LocationResponse(info: Info(count: 0,
                                           pages: 0,
                                           next: "",
                                           previous: ""),
                                results: [
                                    LocationModel(
                                        id: 1,
                                        name: "Earth",
                                        type: "Planet",
                                        dimension: "Dimension C-137",
                                        residents: [
                                          "https://rickandmortyapi.com/api/character/1",
                                          "https://rickandmortyapi.com/api/character/2",
                                        ],
                                        url: "https://rickandmortyapi.com/api/location/1",
                                        created: "2017-11-10T12:42:04.162Z"
                                      )
                                ])
    }

    func fetchEpisodes(page: Int) async throws -> RickAndMortyApp.EpisodeResponse {
        return EpisodeResponse(info: Info(count: 0,
                                          pages: 0,
                                          next: "",
                                          previous: ""),
                               results: [
                                Episode(
                                  id: 1,
                                  name: "Pilot",
                                  airDate: "December 2, 2013",
                                  episode: "S01E01",
                                  characters: [
                                    "https://rickandmortyapi.com/api/character/1",
                                    "https://rickandmortyapi.com/api/character/2",
                                  ],
                                  url: "https://rickandmortyapi.com/api/episode/1",
                                  created: "2017-11-10T12:56:33.798Z"
                                )
                               ])
    }
}
