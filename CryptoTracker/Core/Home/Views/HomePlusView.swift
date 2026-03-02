import SwiftUI

struct HomePlusView: View {
    @State private var showPortfolio = false
    @State private var showPortfolioView = false
    @State private var showSettingsView = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView = false
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                    segmentedToggle
                    searchBarContainer
                    content
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $showDetailView) {
                if let coin = selectedCoin {
                    DetailLoadingView(coin: .constant(coin))
                }
            }
            .sheet(isPresented: $showPortfolioView) {
                PortfolioView()
                    .environmentObject(vm)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if showPortfolio {
                            showPortfolioView.toggle()
                        } else {
                            showSettingsView.toggle()
                        }
                    } label: {
                        Image(systemName: showPortfolio ? "plus" : "info.circle")
                            .font(.title2)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring()) {
                            showPortfolio.toggle()
                        }
                    } label: {
                        Image(systemName: showPortfolio ? "list.bullet" : "chart.pie")
                            .font(.title2)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
        }
    }
}

extension HomePlusView {
    private var header: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.theme.accent.opacity(0.7),
                    Color.blue.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)
            
            HStack {
                Text(showPortfolio ? "Portfolio" : "Live Prices")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white.opacity(0.85), Color.white.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding(.leading, 4)
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 14)
        }
        .frame(height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var segmentedToggle: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring()) {
                    showPortfolio = false
                }
            } label: {
                Text("All")
                    .fontWeight(showPortfolio ? .regular : .bold)
                    .foregroundColor(showPortfolio ? .secondary : Color.theme.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            if !showPortfolio {
                                Capsule()
                                    .fill(Color.theme.accent)
                                    .matchedGeometryEffect(id: "toggle", in: Namespace().wrappedValue)
                            } else {
                                Capsule()
                                    .fill(Color.secondary.opacity(0.15))
                            }
                        }
                    )
            }
            
            Button {
                withAnimation(.spring()) {
                    showPortfolio = true
                }
            } label: {
                Text("Portfolio")
                    .fontWeight(showPortfolio ? .bold : .regular)
                    .foregroundColor(showPortfolio ? Color.theme.accent : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            if showPortfolio {
                                Capsule()
                                    .fill(Color.theme.accent)
                                    .matchedGeometryEffect(id: "toggle", in: Namespace().wrappedValue)
                            } else {
                                Capsule()
                                    .fill(Color.secondary.opacity(0.15))
                            }
                        }
                    )
            }
        }
        .background(
            Capsule()
                .fill(Color.secondary.opacity(0.15))
        )
        .clipShape(Capsule())
        .animation(.spring(), value: showPortfolio)
        .padding(.vertical, 10)
    }
    
    private var searchBarContainer: some View {
        SearchBarView(searchText: $vm.searchText)
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.bottom, 4)
    }
    
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 12, pinnedViews: .sectionHeaders) {
                if vm.isCoinDataLoading {
                    ForEach(0..<15, id: \.self) { _ in
                        CoinRowShimmerView()
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.theme.background.opacity(0.6))
                                    .background(.ultraThinMaterial)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 4)
                    }
                } else {
                    Section(header: listSectionHeader) {
                        ForEach(showPortfolio ? vm.portfolioCoins : vm.allCoins) { coin in
                            coinCard(for: coin, showHoldings: showPortfolio)
                                .onTapGesture {
                                    segue(coin: coin)
                                }
                        }
                    }
                }
            }
            .padding(.top, 4)
            .refreshable {
                vm.reloadData()
            }
        }
    }
    
    private var listSectionHeader: some View {
        HStack {
            // Coin column
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: vm.sortOption == .rank || vm.sortOption == .rankReversed ? "chevron.down" : "chevron.up")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1 : 0)
                    .imageScale(.small)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                withAnimation(.default) {
                    if vm.sortOption == .rank {
                        vm.sortOption = .rankReversed
                    } else {
                        vm.sortOption = .rank
                    }
                }
            }
            
            // Holdings column (only when portfolio shown)
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? "chevron.down" : "chevron.up")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1 : 0)
                        .imageScale(.small)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    withAnimation(.default) {
                        if vm.sortOption == .holdings {
                            vm.sortOption = .holdingsReversed
                        } else {
                            vm.sortOption = .holdings
                        }
                    }
                }
            }
            
            // Price column
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: vm.sortOption == .price || vm.sortOption == .priceReversed ? "chevron.down" : "chevron.up")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1 : 0)
                    .imageScale(.small)
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    if vm.sortOption == .price {
                        vm.sortOption = .priceReversed
                    } else {
                        vm.sortOption = .price
                    }
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            Color.theme.background
                .opacity(0.9)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 4)
    }
    
    @ViewBuilder
    private func coinCard(for coin: CoinModel, showHoldings: Bool) -> some View {
        CoinRowView(coin: coin, showHoldingsColumn: showHoldings)
            .frame(height: 60)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.theme.background.opacity(0.6))
                    .background(.ultraThinMaterial)
            )
            .shadow(color: Color.black.opacity(0.09), radius: 6, x: 0, y: 3)
            .padding(.horizontal, 4)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView = true
    }
}

#Preview {
    HomePlusView()
        .environmentObject(DeveloperPreview.instance.vm)
        .toolbar(.hidden)
}
