import SwiftUI

struct AnimeListView: View {
    @StateObject private var viewModel = AnimeListViewModel()
    
    var body: some View {
        NavigationSplitView {
            sidebarContent
                .navigationTitle("Animes em Alta")
                .navigationSplitViewColumnWidth(min: 300, ideal: 360, max: 420)
        } detail: {
            if let selectedAnime = viewModel.selectedAnime {
                AnimeDetailView(anime: selectedAnime, viewModel: viewModel)
            } else {
                emptyDetailView
            }
        }
        .searchable(text: $viewModel.searchText, placement: .toolbar, prompt: "Buscar anime...")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                // Refresh Button
                Button(action: { viewModel.refresh() }) {
                    Label("Atualizar", systemImage: "arrow.clockwise")
                }
                .keyboardShortcut("r", modifiers: .command)
                .disabled(viewModel.isLoading)
                .help("Atualizar lista de animes")
                
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .controlSize(.small)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
    }
    
    @ViewBuilder
    private var sidebarContent: some View {
        if viewModel.isLoading && viewModel.animes.isEmpty {
            // Initial loading state
            VStack {
                ProgressView("Carregando animes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else if let error = viewModel.errorMessage, viewModel.animes.isEmpty {
            // Error state
            ErrorStateView(message: error) {
                viewModel.refresh()
            }
        } else if viewModel.isEmpty {
            // Empty state
            ContentUnavailableView(
                "Nenhum anime encontrado",
                systemImage: "tv.slash",
                description: Text("Tente atualizar a lista")
            )
        } else {
            // Content list minimalista
            List(viewModel.filteredAnimes, selection: $viewModel.selectedAnime) { anime in
                AnimeRow(anime: anime)
                    .tag(anime)
                    .task { viewModel.loadMoreIfNeeded(current: anime) }
            }
            .listStyle(.sidebar)
            .accessibilityLabel("Lista de animes")
        }
    }
    
    private var emptyDetailView: some View {
        ContentUnavailableView(
            "Selecione um anime",
            systemImage: "tv",
            description: Text("Escolha um anime da lista para ver os detalhes")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
