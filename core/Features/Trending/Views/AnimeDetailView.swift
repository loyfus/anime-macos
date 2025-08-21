import SwiftUI
import AppKit

struct AnimeDetailView: View {
    let anime: Anime
    @ObservedObject var viewModel: AnimeListViewModel
    @State private var isImageHovered = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with cover and basic info
                HStack(alignment: .top, spacing: 20) {
                    // Cover Image
                    AsyncImage(url: URL(string: anime.coverImage.bestAvailable ?? "")) { phase in
                        switch phase {
                        case .empty:
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 250, height: 375)
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 250, maxHeight: 375)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .failure(_):
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 250, height: 375)
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .accessibilityLabel("Capa de \(anime.displayTitle)")
                    
                    // Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        // Title
                        Text(anime.displayTitle)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Metadados condensados
                        HStack(spacing: 12) {
                            Label(anime.formattedScore, systemImage: "star.fill")
                            if let _ = anime.episodes { Label(anime.formattedEpisodes + " eps", systemImage: "tv") }
                            if !anime.formattedYear.isEmpty { Label(anime.formattedYear, systemImage: "calendar") }
                            if let pop = anime.popularity {
                                let formatted = (Anime(id: 0, title: Title(romaji: nil, english: nil, native: nil), coverImage: CoverImage(medium: nil, large: nil, extraLarge: nil), averageScore: nil, popularity: pop, episodes: nil, seasonYear: nil, description: nil, trailer: nil, streamingEpisodes: nil, externalLinks: nil)).formattedPopularity
                                Label(formatted, systemImage: "flame.fill")
                            }
                        }
                        .foregroundColor(.secondary)
                        .font(.callout)
                        
                        // Open in AniList Button
                        Button(action: openInAniList) {
                            Label("Abrir no AniList", systemImage: "safari")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .keyboardShortcut("o", modifiers: .command)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.trailing)
                
                // Streaming Section
                if let externalLinks = anime.externalLinks {
                    let streamingLinks = externalLinks.filter { $0.isStreamingService }
                    if !streamingLinks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Onde Assistir").font(.title3).bold()
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(streamingLinks, id: \.id) { link in
                                        Button(action: {
                                            if let url = URL(string: link.url) {
                                                NSWorkspace.shared.open(url)
                                            }
                                        }) {
                                            VStack(spacing: 8) {
                                                if let icon = link.icon, let iconURL = URL(string: icon) {
                                                    AsyncImage(url: iconURL) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 40, height: 40)
                                                        default:
                                                            Image(systemName: "play.circle.fill")
                                                                .font(.system(size: 40))
                                                                .foregroundColor(.accentColor)
                                                        }
                                                    }
                                                } else {
                                                    Image(systemName: "play.circle.fill")
                                                        .font(.system(size: 40))
                                                        .foregroundColor(.accentColor)
                                                }
                                                Text(link.site)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                                    .frame(maxWidth: 80)
                                            }
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                        }
                                        .buttonStyle(.borderless)
                                        .help("Abrir \(link.site)")
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                
                // Trailer Section
                if let trailer = anime.trailer, trailer.url != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Trailer").font(.title3).bold()
                        Button(action: {
                            if let url = trailer.url {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            HStack(spacing: 12) {
                                if let thumbnail = trailer.thumbnail, let thumbnailURL = URL(string: thumbnail) {
                                    AsyncImage(url: thumbnailURL) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(16/9, contentMode: .fit)
                                                .frame(width: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .overlay(
                                                    Image(systemName: "play.circle.fill")
                                                        .font(.largeTitle)
                                                        .foregroundColor(.white)
                                                        .shadow(radius: 4)
                                                )
                                        default:
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 200, height: 112)
                                                .overlay(
                                                    Image(systemName: "play.circle.fill")
                                                        .font(.largeTitle)
                                                        .foregroundColor(.white)
                                                )
                                        }
                                    }
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 200, height: 112)
                                        .overlay(
                                            Image(systemName: "play.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Assistir no \(trailer.site ?? "YouTube")")
                                        .font(.headline)
                                    Text("Clique para abrir o trailer")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                        .help("Abrir trailer no \(trailer.site ?? "YouTube")")
                    }
                }
                
                // Description Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sinopse").font(.title3).bold()
                    if let description = viewModel.animeDescriptions[anime.id] {
                        Text(description)
                            .font(.body)
                            .lineSpacing(4)
                            .textSelection(.enabled)
                    } else {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Carregando sinopse...")
                                .foregroundColor(.secondary)
                        }
                        .task { viewModel.loadDescriptionIfNeeded(for: anime) }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .frame(minWidth: 600)
        .navigationTitle(anime.displayTitle)
        .navigationSubtitle("Detalhes do Anime")
    }
    
    private func openInAniList() {
        NSWorkspace.shared.open(anime.aniListURL)
    }
}
