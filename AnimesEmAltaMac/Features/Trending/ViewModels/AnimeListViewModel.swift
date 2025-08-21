import Foundation
import SwiftUI

@MainActor
class AnimeListViewModel: ObservableObject {
    @Published var animes: [Anime] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedAnime: Anime?
    @Published var animeDescriptions: [Int: String] = [:]
    
    private let service = AnimeService.shared
    private var currentPage = 1
    private var hasMorePages = true
    private var isLoadingMore = false
    
    var filteredAnimes: [Anime] {
        if searchText.isEmpty {
            return animes
        }
        return animes.filter { anime in
            anime.displayTitle.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var isEmpty: Bool {
        animes.isEmpty && !isLoading
    }
    
    // MARK: - Public Methods
    
    func refresh() {
        Task {
            await load(reset: true)
        }
    }
    
    func loadMoreIfNeeded(current anime: Anime) {
        guard let index = animes.firstIndex(where: { $0.id == anime.id }),
              index >= animes.count - 5,
              hasMorePages,
              !isLoadingMore else { return }
        
        Task {
            await loadMore()
        }
    }
    
    func loadDescriptionIfNeeded(for anime: Anime) {
        guard animeDescriptions[anime.id] == nil else { return }
        
        Task {
            do {
                if let description = try await service.fetchDescription(id: anime.id) {
                    animeDescriptions[anime.id] = description
                }
            } catch {
                print("Erro ao carregar descrição: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func load(reset: Bool = false) async {
        guard !isLoading else { return }
        
        if reset {
            currentPage = 1
            hasMorePages = true
            animeDescriptions.removeAll()
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedAnimes = try await service.fetchTrending(page: currentPage)
            
            if reset {
                animes = fetchedAnimes
            } else {
                animes.append(contentsOf: fetchedAnimes)
            }
            
            hasMorePages = !fetchedAnimes.isEmpty
            
            if !fetchedAnimes.isEmpty {
                currentPage += 1
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func loadMore() async {
        guard !isLoadingMore, hasMorePages else { return }
        
        isLoadingMore = true
        
        do {
            let fetchedAnimes = try await service.fetchTrending(page: currentPage)
            animes.append(contentsOf: fetchedAnimes)
            
            hasMorePages = !fetchedAnimes.isEmpty
            
            if !fetchedAnimes.isEmpty {
                currentPage += 1
            }
        } catch {
            print("Erro ao carregar mais: \(error)")
        }
        
        isLoadingMore = false
    }
    
    // MARK: - Initialization
    
    func onAppear() {
        if animes.isEmpty {
            refresh()
        }
    }
}