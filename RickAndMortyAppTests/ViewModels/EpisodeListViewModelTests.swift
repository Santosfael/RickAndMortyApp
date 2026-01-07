//
//  EpisodeListViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 06/01/26.
//

import XCTest
@testable import RickAndMortyApp

final class EpisodeListViewModelTests: XCTestCase {

    @MainActor
    func testLoadEpisodeSuccessShouldPopulateCharacters() async {
        let service = MockApiService()
        let viewModel = EpisodeListViewModel(apiService: service)
        await viewModel.fetchEpisodes()
        
        XCTAssertEqual(viewModel.episodes.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testLoadEpisodeSuccessShouldSetErroMessage() async {
        let service = MockApiServiceFailure()
        let viewModel = EpisodeListViewModel(apiService: service)
        
        await viewModel.fetchEpisodes()
        
        XCTAssertTrue(viewModel.episodes.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Request Failed")
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testLoadEpisodeSuccessShouldToggleLoadingState() async {
        let service = MockApiServiceDelayed()
        let viewModel = EpisodeListViewModel(apiService: service)
        
        let task = Task {
            await viewModel.fetchEpisodes()
        }
        
        await Task.yield()
        
        XCTAssertTrue(viewModel.isLoading)
        
        await task.value
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testLoadMoreEpisodeShouldAppendNewPage() async {
        let service = MockApiServicePagination()
        let viewModel = EpisodeListViewModel(apiService: service)
        
        viewModel.episodes = [
            Episode(
              id: 2,
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
        ]
        
        await viewModel.loadMoreEpisodes()
        
        XCTAssertEqual(viewModel.episodes.count, 2)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testLoadMoreEpisodeShouldNotLoadWhenNotMorePage() async {
        let service = MockApiServicePagination()
        let viewModel = EpisodeListViewModel(apiService: service)
        
        viewModel.hasMorePages = false
        viewModel.episodes = [
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
        ]
        
        await viewModel.loadMoreEpisodes()
        
        XCTAssertEqual(viewModel.episodes.count, 1)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testLoadMoreEpisodeShouldSetErrorMessage() async {
        let service = MockApiServiceFailure()
        let viewModel = EpisodeListViewModel(apiService: service)
        
        viewModel.hasMorePages = true
        await viewModel.loadMoreEpisodes()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

}
