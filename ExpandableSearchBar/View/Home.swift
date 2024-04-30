//
//  Home.swift
//  ExpandableSearchBar
//
//  Created by Mohsin Ali Ayub on 29.04.24.
//

import SwiftUI

struct Home: View {
    // View properties
    @State private var searchText = ""
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                dummyMessagesView
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                expandableNavBar()
            }
        }
        .background(.gray.opacity(0.15))
    }
    
    /// Expandable navigation bar.
    @ViewBuilder
    func expandableNavBar(_ title: String = "Messages") -> some View {
        VStack {
            // Title
            Text(title)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            // Search bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                
                TextField("Search conversations", text: $searchText)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .frame(height: 45)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.background)
            }
        }
        .padding(.top, 25)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
    
    /// A message view list with placeholders for both picture and message content.
    @ViewBuilder
    var dummyMessagesView: some View {
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
