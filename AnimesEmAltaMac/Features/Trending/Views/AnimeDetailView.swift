import SwiftUI
import AppKit

struct AnimeDetailView: View {
    let anime: Anime
    @ObservedObject var viewModel: AnimeListViewModel
    @State private var isImageHovered = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                                .shadow(radius: isImageHovered ? 8 : 4)
                                .scaleEffect(isImageHovered ? 1.02 : 1.0)
                                .onHover { hovering in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isImageHovered = hovering
                                    }
                                }
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
                    VStack(alignment: .leading, spacing: 16) {
                        // Title
                        Text(anime.displayTitle)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Metadata Grid
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 20) {
                                // Score
                                VStack(alignment: .leading) {
                                    Label("Avaliação", systemImage: "star.fill")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(anime.formattedScore)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.orange)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Avaliação: \(anime.formattedScore)")
                                
                                // Popularity
                                VStack(alignment: .leading) {
                                    Label("Popularidade", systemImage: "flame.fill")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(anime.formattedPopularity)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.red)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Popularidade: \(anime.formattedPopularity)")
                            }
                            
                            HStack(spacing: 20) {
                                // Episodes
                                if anime.episodes != nil {
                                    VStack(alignment: .leading) {
                                        Label("Episódios", systemImage: "tv")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(anime.formattedEpisodes)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.blue)
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("\(anime.formattedEpisodes) episódios")
                                }
                                
                                // Year
                                if !anime.formattedYear.isEmpty {
                                    VStack(alignment: .leading) {
                                        Label("Ano", systemImage: "calendar")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(anime.formattedYear)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("Ano: \(anime.formattedYear)")
                                }
                            }
                        }
                        
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
                .padding()
                
                Divider()
                
                // Streaming Section
                if let externalLinks = anime.externalLinks {
                    let streamingLinks = externalLinks.filter { $0.isStreamingService }
                    if !streamingLinks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Onde Assistir")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
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
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                        }
                                        .buttonStyle(.plain)
                                        .help("Abrir \(link.site)")
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        
                        Divider()
                    }
                }
                
                // Trailer Section
                if let trailer = anime.trailer, trailer.url != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trailer")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
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
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        .help("Abrir trailer no \(trailer.site ?? "YouTube")")
                    }
                    .padding()
                    
                    Divider()
                }
                
                // Description Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sinopse")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
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
                        .task {
                            viewModel.loadDescriptionIfNeeded(for: anime)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 600)
        .navigationTitle(anime.displayTitle)
        .navigationSubtitle("Detalhes do Anime")
    }
    
    private func openInAniList() {
        NSWorkspace.shared.open(anime.aniListURL)
    }
}