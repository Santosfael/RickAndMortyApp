//
//  EpisodeIntegrationTests.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 12/01/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class EpisodeIntegrationTests: XCTestCase {

    var spyService: SpyApiService!
    var viewModel: EpisodeListViewModel!

    override func setUp() {
        super.setUp()
        spyService = SpyApiService()
        viewModel = EpisodeListViewModel(apiService: spyService)
    }

    override func tearDown() {
        spyService = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchEpisodesIntegration_Success() async throws {
        // ARRANGE
        XCTAssertTrue(viewModel.episodes.isEmpty)
        
        // ACT
        await viewModel.fetchEpisodes()

        // ASSERT
        XCTAssertFalse(viewModel.episodes.isEmpty)
        XCTAssertEqual(viewModel.episodes.count, 2)
        XCTAssertEqual(viewModel.episodes.first?.name, "Pilot")
        XCTAssertEqual(viewModel.episodes.first?.episode, "S01E01")
        XCTAssertEqual(spyService.fetchEpisodesCallCount, 1)
    }

    func testLoadMoreEpisodesIntegration() async throws {
        // ARRANGE
        await viewModel.fetchEpisodes()
        let initialCount = viewModel.episodes.count
        
        // ACT
        await viewModel.loadMoreEpisodes()
        
        // ASSERT
        XCTAssertEqual(viewModel.episodes.count, initialCount + 2)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertEqual(spyService.fetchEpisodesCallCount, 2)
    }

    func testFetchEpisodesIntregration_Failure() async throws {
        // ARRANGE
        spyService.shouldReturnError = true
        
        // ACT
        await viewModel.fetchEpisodes()
        
        // ASSERT
        XCTAssertTrue(viewModel.episodes.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testRefreshEpisodesIntegration() async throws {
        // ARRANGE
        await viewModel.fetchEpisodes()
        await viewModel.loadMoreEpisodes()
        XCTAssertEqual(viewModel.currentPage, 2)

        // ACT
        await viewModel.refreshLocations()

        // ASSERT
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.episodes.count, 2)
        XCTAssertEqual(spyService.fetchEpisodesCallCount, 3)
    }
}
