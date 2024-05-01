//
//  ContentView.swift
//  ExpandableSearchBar
//
//  Created by Mohsin Ali Ayub on 29.04.24.
//

import SwiftUI

struct ContentView: View {
    private let title = "Messages"
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            Home(title: title, searchText: $searchText) {
                dummyMessagesView
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private var dummyMessagesView: some View {
        ForEach(0..<20, id: \.self) { _ in
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()
                        .frame(width: 140, height: 8)
                    Rectangle()
                        .frame(height: 8)
                    Rectangle()
                        .frame(width: 80, height: 8)
                }
            }
            .foregroundStyle(.gray.opacity(0.25))
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    ContentView()
}
