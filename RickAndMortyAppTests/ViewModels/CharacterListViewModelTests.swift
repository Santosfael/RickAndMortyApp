//
//  CharacterListViewModel.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 06/01/26.
//

import XCTest
@testable import RickAndMortyApp
final class CharacterListViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testLoadCharactersSuccessShouldPopulateCharacters() async {
        let service = MockCharacterService()
        let viewModel = CharacterListViewModel(characterService: service)
        await viewModel.fetchCharacters()
        
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testLoadCharactersSuccessShouldSetErroMessage() async {
        let service = MockCharacterServiceFailure()
        let viewModel = CharacterListViewModel(characterService: service)
        
        await viewModel.fetchCharacters()
        
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Request Failed")
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testLoadCharactersSuccessShouldToggleLoadingState() async {
        let service = MockCharacterServiceDelayed()
        let viewModel = CharacterListViewModel(characterService: service)
        
        let task = Task {
            await viewModel.fetchCharacters()
        }
        
        await Task.yield()
        
        XCTAssertTrue(viewModel.isLoading)
        
        await task.value
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testLoadMoreCharactersShouldAppendNewPage() async {
        let service = MockCharacterServicePagination()
        let viewModel = CharacterListViewModel(characterService: service)
        
        viewModel.characters = [
            Character(id: 362,
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
        ]
        
        await viewModel.loadModeCharacters()
        
        XCTAssertEqual(viewModel.characters.count, 2)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testLoadMoreCharactersShouldNotLoadWhenNotMorePage() async {
        let service = MockCharacterServicePagination()
        let viewModel = CharacterListViewModel(characterService: service)
        
        viewModel.hasMorePages = false
        viewModel.characters = [
            Character(id: 362,
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
        ]
        
        await viewModel.loadModeCharacters()
        
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testLoadMoreCharactersShouldSetErrorMessage() async {
        let service = MockCharacterServiceFailure()
        let viewModel = CharacterListViewModel(characterService: service)
        
        viewModel.hasMorePages = true
        await viewModel.loadModeCharacters()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}
