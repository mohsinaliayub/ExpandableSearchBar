//
//  ContentView.swift
//  ExpandableSearchBar
//
//  Created by Mohsin Ali Ayub on 29.04.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
