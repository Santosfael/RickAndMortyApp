//
//  LocationListViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Rafael on 06/01/26.
//

import XCTest
@testable import RickAndMortyApp

final class LocationListViewModelTests: XCTestCase {

    @MainActor
    func testLoadLocationSuccessShouldPopulateCharacters() async {
        let service = MockApiService()
        let viewModel = LocationListViewModel(apiService: service)
        await viewModel.fetchLocations()
        
        XCTAssertEqual(viewModel.locations.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testLoadLocationSuccessShouldSetErroMessage() async {
        let service = MockApiServiceFailure()
        let viewModel = LocationListViewModel(apiService: service)
        
        await viewModel.fetchLocations()
        
        XCTAssertTrue(viewModel.locations.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Request Failed")
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testLoadLocationSuccessShouldToggleLoadingState() async {
        let service = MockApiServiceDelayed()
        let viewModel = LocationListViewModel(apiService: service)
        
        let task = Task {
            await viewModel.fetchLocations()
        }
        
        await Task.yield()
        
        XCTAssertTrue(viewModel.isLoading)
        
        await task.value
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testLoadMoreLocationShouldAppendNewPage() async {
        let service = MockApiServicePagination()
        let viewModel = LocationListViewModel(apiService: service)
        
        viewModel.locations = [
            Location(
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
        ]
        
        await viewModel.loadMoreLocations()
        
        XCTAssertEqual(viewModel.locations.count, 2)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testLoadMoreLocationShouldNotLoadWhenNotMorePage() async {
        let service = MockApiServicePagination()
        let viewModel = LocationListViewModel(apiService: service)
        
        viewModel.hasMorePages = false
        viewModel.locations = [
            Location(
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
        ]
        
        await viewModel.loadMoreLocations()
        
        XCTAssertEqual(viewModel.locations.count, 1)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testLoadMoreLocationShouldSetErrorMessage() async {
        let service = MockApiServiceFailure()
        let viewModel = LocationListViewModel(apiService: service)
        
        viewModel.hasMorePages = true
        await viewModel.loadMoreLocations()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

}
