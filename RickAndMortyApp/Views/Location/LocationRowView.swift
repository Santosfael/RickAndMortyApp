//
//  LocationRowView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import SwiftUI

struct LocationRowView: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.headline)
                .foregroundStyle(.blue)
            
            HStack {
                Image(systemName: "globe")
                    .foregroundStyle(.blue)
                
                Text(location.type)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(.purple)
                
                Text(location.dimension)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(.green)
                
                Text("\(location.residents.count) residents")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5)
    }
}

#Preview {
    LocationRowView(location: Location(id: 1,
                                       name: "Earth",
                                       type: "Planet",
                                       dimension: "Dimension c-137",
                                       residents: [
                                        "https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"
                                       ],
                                       url: "https://rickandmortyapi.com/api/location/1",
                                       created: "2017-11-10T12:42:04.162Z"))
}
