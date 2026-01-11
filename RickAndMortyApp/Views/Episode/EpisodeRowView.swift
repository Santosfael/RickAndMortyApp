//
//  EpisodeRowView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import SwiftUI

struct EpisodeRowView: View {
    let episode: Episode

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(width: 70, height: 70)
                
                VStack(spacing: 4) {
                    Text(String(episode.episode.prefix(3)))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text (String(episode.episode.suffix(3)))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(episode.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.orange)
                        .font(.caption)
                    
                    Text(episode.airDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    
                    
                    Text("\(episode.characters.count) characters")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.leading, 8)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5)
    }
}

#Preview {
    EpisodeRowView(episode: Episode(id: 1,
                                    name: "Pilot",
                                    airDate: "December 2, 2013",
                                    episode: "S01E01",
                                    characters: [
                                        "https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"
                                    ],
                                    url: "https://rickandmortyapi.com/api/episode/1",
                                    created: "2017-11-10T12:56:33.798Z"))
}
