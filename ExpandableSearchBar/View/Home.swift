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
        .contentMargins(.top, Constants.navBarHeight, for: .scrollIndicators)
    }
    
    /// Expandable navigation bar.
    @ViewBuilder
    func expandableNavBar(_ title: String = "Messages") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + (max(min(minY / scrollViewHeight, 1), 0) * 0.5) : 1
            // Just a random value. The lower the value, the faster the scroll animation will be.
            let progress = isSearching ? 1 : max(min(-minY / Constants.stretchedNavBarHeight, 1), 0)
            
            VStack {
                // Title
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, Constants.bottomPadding)
                
                // Search bar
                HStack {
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
                .padding(.vertical, Constants.bottomPadding)
                .padding(.horizontal, Constants.horizontalPadding - (progress * Constants.horizontalPadding))
                .frame(height: Constants.searchBarHeight)
                .clipShape(Capsule())
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadiusSearchBar - (progress * Constants.cornerRadiusSearchBar))
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        // When scrolled up, it will fill the nav bar with background color
                        .padding(.top, -progress * Constants.navBarHeight)
                        .padding(.bottom, -progress * Constants.stretchedNavBarHeight)
                        .padding(.horizontal, -progress * Constants.horizontalPadding)
                }
                
                // Custom Segmented Picker
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (scheme == .dark ? .black : .white) : .primary)
                                    .padding(.vertical, Constants.verticalPadding)
                                    .padding(.horizontal, Constants.horizontalPadding)
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
                .frame(height: Constants.segmentedPickersHeight)
            }
            .padding(.top, Constants.searchBarTopPadding)
            .safeAreaPadding(.horizontal, Constants.horizontalPadding)
            // making nav bar always appear at top when search is active
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * Constants.stretchedNavBarHeight)
        }
        .frame(height: Constants.navBarHeight)
        .padding(.bottom, Constants.bottomPadding)
        // remove extra space between nav bar and dummy messages when search is active
        .padding(.bottom, isSearching ? -Constants.stretchedNavBarHeight : 0)
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

enum Constants {
    static let navBarHeight: CGFloat = 190
    static let stretchedNavBarHeight: CGFloat = 65
    static let horizontalPadding: CGFloat = 15
    static let searchBarHeight: CGFloat = 45
    static let segmentedPickersHeight: CGFloat = 50
    static let verticalPadding: CGFloat = 8
    static let bottomPadding: CGFloat = 10
    static let searchBarTopPadding: CGFloat = 25
    static let cornerRadiusSearchBar: CGFloat = 25
}

// IMP: The view may appear uneven if the user stops scrolling in the middle of
// a scroll transition. In certain circumstances, we may use the new Scroll target
// Behavior to detect when the dragging is complete, allowing us to either reset the
// transition to its start phase or finish it based on the end target value.
struct CustomScrollTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < Constants.stretchedNavBarHeight {
            if target.rect.minY < Constants.stretchedNavBarHeight / 2 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: Constants.stretchedNavBarHeight)
            }
        }
    }
}

#Preview {
    Home()
}
