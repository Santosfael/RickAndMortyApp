//
//  LocationIntegrationTests.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 12/01/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class LocationIntegrationTests: XCTestCase {

    var spyAPIService: SpyApiService!
    var viewModel: LocationListViewModel!

    override func setUp() {
        super.setUp()
        spyAPIService = SpyApiService()
        viewModel = LocationListViewModel(apiService: spyAPIService)
    }

    override func tearDown() {
        spyAPIService = nil
        viewModel = nil
        super.tearDown()
    }

    // Testar o fluxo completo de busca de localizações
    func testFetchLocationsIntegration_Sucess() async throws {
        // ARRANGE
        XCTAssertTrue(viewModel.locations.isEmpty)
        
        // ACT
        await viewModel.fetchLocations()
        
        // ASSERT
        XCTAssertFalse(viewModel.locations.isEmpty)
        XCTAssertEqual(viewModel.locations.count, 2)
        XCTAssertEqual(viewModel.locations.first?.name, "Earth (C-137)")
        XCTAssertEqual(viewModel.locations.first?.type, "Planet")
        XCTAssertEqual(spyAPIService.fetchLocationCallCount, 1)
    }

    // Testar paginação de localizações
    func testLoadMoreLocationsIntregration() async throws {
        // ARRANGE
        await viewModel.fetchLocations()
        let initialCount = viewModel.locations.count

        // ACT
        await viewModel.loadMoreLocations()

        // ASSERT
        XCTAssertEqual(viewModel.locations.count, initialCount + 2)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertEqual(spyAPIService.fetchLocationCallCount, 2)
    }

    //Testa tratamento de erro
    func testFetchLocationsIntegration_Failure() async throws {
        // ARRANGE
        spyAPIService.shouldReturnError = true

        // ACT
        await viewModel.fetchLocations()

        // ASSERT
        XCTAssertTrue(viewModel.locations.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    // Testa REFRESH (pull to refresh)
    // Verifica se dados são recarregados do zero
    func testRefreshLocationsIntegration() async throws {
        // ARRANGE
        // Carrega algumas páginas
        await viewModel.fetchLocations()
        await viewModel.loadMoreLocations()
        XCTAssertEqual(viewModel.currentPage, 2, "Should be on page 2")
        
        // ACT
        // Faz refresh
        await viewModel.refreshLocations()
        
        // ASSERT
        XCTAssertEqual(viewModel.currentPage, 1, "Should reset to page 1")
        XCTAssertEqual(viewModel.locations.count, 2, "Should have only page 1 data")
        XCTAssertEqual(spyAPIService.fetchLocationCallCount, 3, "API should be called 3 times total")
    }
}
