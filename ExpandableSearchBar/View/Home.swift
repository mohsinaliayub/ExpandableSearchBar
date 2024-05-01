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
    @FocusState private var isSearching: Bool
    @State private var activeTab: Tab = .all
    @Environment(\.colorScheme) private var scheme
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                dummyMessagesView
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                expandableNavBar()
            }
            .animation(.snappy(duration: 0.3), value: isSearching)
        }
        .scrollTargetBehavior(CustomScrollTargetBehavior())
        .background(.gray.opacity(0.15))
        .contentMargins(.top, 190, for: .scrollIndicators)
    }
    
    /// Expandable navigation bar.
    @ViewBuilder
    func expandableNavBar(_ title: String = "Messages") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            // Just a random value. The lower the value, the faster the scroll animation will be.
            let progress = isSearching ? 1 : max(min(-minY / 70, 1), 0)
            
            
            
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
                        .focused($isSearching)
                    
                    if isSearching {
                        Button(action: {
                            isSearching = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.title3)
                        }
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 15 - (progress * 15))
                .frame(height: 45)
                .clipShape(Capsule())
                .background {
                    RoundedRectangle(cornerRadius: 25 - (progress * 25))
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        // When scrolled up, it will fill the nav bar with background color
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 65)
                        .padding(.horizontal, -progress * 15)
                }
                
                // Custom Segmented Picker
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (scheme == .dark ? .black : .white) : .primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 50)
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            // making nav bar always appear at top when search is active
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
        }
        .frame(height: 190)
        .padding(.bottom, 10)
        // remove extra space between nav bar and dummy messages when search is active
        .padding(.bottom, isSearching ? -65 : 0)
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

// IMP: The view may appear uneven if the user stops scrolling in the middle of
// a scroll transition. In certain circumstances, we may use the new Scroll target
// Behavior to detect when the dragging is complete, allowing us to either reset the
// transition to its start phase or finish it based on the end target value.
struct CustomScrollTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}

#Preview {
    ContentView()
}
