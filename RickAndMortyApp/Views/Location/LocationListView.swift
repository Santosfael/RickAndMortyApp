//
//  LocationListView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import SwiftUI

struct LocationListView: View {
    // @StateObject: cria e mantém a instância do ViewModel
    // Garante que o ViewModel não seja recriado a cada re-renderização
    @StateObject private var viewModel: LocationListViewModel
    
    init(viewModel: LocationListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView {
            
            if viewModel.locations.isEmpty && !viewModel.isLoading {
                Text("No locations found")
                    .foregroundStyle(.gray)
            } else {
                // ScrollView: permite rolagem vertical
                ScrollView {
                    // LazyVStack: carrega views sob demanda (performance)
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.locations) { location in
                            LocationRowView(location: location)
                                .padding(.horizontal)
                                .onAppear {
                                    if location.id == viewModel.locations.last?.id {
                                        Task {
                                            await viewModel.loadMoreLocations()
                                        }
                                    }
                                }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.vertical)
                }
                // Gesture nativo do iOS: puxar para baixo atualiza
                .refreshable {
                    await viewModel.refreshLocations()
                }
            }
            
            if viewModel.isLoading && viewModel.locations.isEmpty {
                ProgressView("Loading locations...")
                    .scaleEffect(1.5)
            }
        }
        .navigationTitle("Locations")
        .alert(item: Binding<AlertItem?>(
            get: { viewModel.errorMessage != nil ? AlertItem(message: viewModel.errorMessage!): nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            alertItem in
            Alert(title: Text("Error"),
                  message: Text(alertItem.message),
                  dismissButton: .default(Text("OK"))
            )
        }
        .task {
            await viewModel.fetchLocations()
        }
    }
}

#Preview {
    LocationListView(viewModel: LocationListViewModel(apiService: APIService()))
}
