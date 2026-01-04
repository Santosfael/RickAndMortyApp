//
//  CharacterDetailItemView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 04/01/26.
//

import SwiftUI

struct CharacterDetailItemView: View {
    let title: String
    let value: String
    var isStatus = false
    var status: String? = nil
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.headline)
            Spacer()
        
            if (isStatus) {
                Circle()
                    .fill(statusColor(for: status ?? ""))
                    .frame(width: 10, height: 10)
            }
            
            Text(value)
                .font(.subheadline)
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "alive":
            return .green
        case "dead":
            return .red
        default:
            return .gray
        }
    }
}

#Preview {
    CharacterDetailItemView(title: "Status", value: "Dead", isStatus: true, status: "Dead")
}
