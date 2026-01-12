//
//  TestData.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import Foundation
@testable import RickAndMortyApp

// EXPLICAÇÃO:
// TestData fornece dados FAKE para testes
// Simula respostas da API sem fazer requisições reais
struct TestData {
    
    // MARK: - Character Test Data
    
    // EXPLICAÇÃO:
    // Cria um personagem fake para testes
    // Todos os campos necessários estão preenchidos
    static let mockCharacter = Character(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
        location: LocationPerson(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: ["https://rickandmortyapi.com/api/episode/1"],
        url: "https://rickandmortyapi.com/api/character/1",
        created: "2017-11-04T18:48:46.250Z"
    )
    
    // EXPLICAÇÃO:
    // Lista de múltiplos personagens para testar paginação
    static let mockCharacters: [Character] = [
        mockCharacter,
        Character(
            id: 2,
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
            location: LocationPerson(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            episode: ["https://rickandmortyapi.com/api/episode/1"],
            url: "https://rickandmortyapi.com/api/character/2",
            created: "2017-11-04T18:50:21.651Z"
        ),
        Character(
            id: 3,
            name: "Summer Smith",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Female",
            origin: Origin(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
            location: LocationPerson(name: "Earth (Replacement Dimension)", url: "https://rickandmortyapi.com/api/location/20"),
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            episode: ["https://rickandmortyapi.com/api/episode/6"],
            url: "https://rickandmortyapi.com/api/character/3",
            created: "2017-11-04T19:09:56.428Z"
        )
    ]
    
    // EXPLICAÇÃO:
    // Resposta paginada simulada
    static let mockCharacterResponse = CharacterResponse(
        info: Info(
            count: 826,
            pages: 42,
            next: "https://rickandmortyapi.com/api/character?page=2",
            previous: nil
        ),
        results: mockCharacters
    )
    
    // MARK: - Location Test Data
    
    static let mockLocation = RickAndMortyApp.Location(
        id: 1,
        name: "Earth (C-137)",
        type: "Planet",
        dimension: "Dimension C-137",
        residents: [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2"
        ],
        url: "https://rickandmortyapi.com/api/location/1",
        created: "2017-11-10T12:42:04.162Z"
    )
    
    static let mockLocations: [RickAndMortyApp.Location] = [
        mockLocation,
        RickAndMortyApp.Location(
            id: 2,
            name: "Citadel of Ricks",
            type: "Space station",
            dimension: "unknown",
            residents: ["https://rickandmortyapi.com/api/character/8"],
            url: "https://rickandmortyapi.com/api/location/2",
            created: "2017-11-10T13:08:13.191Z"
        )
    ]
    
    static let mockLocationResponse = LocationResponse(
        info: Info(
            count: 126,
            pages: 7,
            next: "https://rickandmortyapi.com/api/location?page=2",
            previous: nil
        ),
        results: mockLocations
    )
    
    // MARK: - Episode Test Data
    
    static let mockEpisode = Episode(
        id: 1,
        name: "Pilot",
        airDate: "December 2, 2013",
        episode: "S01E01",
        characters: [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2"
        ],
        url: "https://rickandmortyapi.com/api/episode/1",
        created: "2017-11-10T12:56:33.798Z"
    )
    
    static let mockEpisodes: [Episode] = [
        mockEpisode,
        Episode(
            id: 2,
            name: "Lawnmower Dog",
            airDate: "December 9, 2013",
            episode: "S01E02",
            characters: ["https://rickandmortyapi.com/api/character/1"],
            url: "https://rickandmortyapi.com/api/episode/2",
            created: "2017-11-10T12:56:33.916Z"
        )
    ]
    
    static let mockEpisodeResponse = EpisodeResponse(
        info: Info(
            count: 51,
            pages: 3,
            next: "https://rickandmortyapi.com/api/episode?page=2",
            previous: nil
        ),
        results: mockEpisodes
    )
    
    // MARK: - Error Scenarios
    
    // EXPLICAÇÃO:
    // Respostas vazias para testar cenários de erro
    static let emptyCharacterResponse = CharacterResponse(
        info: Info(count: 0, pages: 0, next: nil, previous: nil),
        results: []
    )
}
