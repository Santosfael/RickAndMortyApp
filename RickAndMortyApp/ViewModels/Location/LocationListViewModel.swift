//
//  LocationListViewModel.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation
internal import Combine

// @MainActor: garante que TODAS as atualizações de UI aconteçam na thread principal
// Isso evita crashes e problemas de sincronização
@MainActor
final class LocationListViewModel: ObservableObject {

    // @Published: quando a propriedade muda, notifica automaticamente as Views
    // As Views que observam esse ViewModel serão re-renderizadas
    @Published var locations: [LocationModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    @Published var hasMorePages = true
    
    private var isLoadingMore = false
    
    private var apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    internal func fetchLocations() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.fetchLocations(page: 1)
            locations = response.results
            currentPage = 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    internal func loadMoreLocations() async {
        guard hasMorePages, !isLoading else { return }
        
        isLoadingMore = true
        
        do {
            let response = try await apiService.fetchLocations(page: currentPage + 1)
            locations.append(contentsOf: response.results)
            currentPage += 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    internal func refreshLocations() async {
        await fetchLocations()
    }
}
