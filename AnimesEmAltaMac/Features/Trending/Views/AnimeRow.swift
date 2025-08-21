import SwiftUI

struct AnimeRow: View {
    let anime: Anime
    
    var body: some View {
        HStack(spacing: 12) {
            // Cover Image
            AsyncImage(url: URL(string: anime.coverImage.medium ?? "")) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 64, height: 96)
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.5)
                        )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure(_):
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 64, height: 96)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .accessibilityLabel("Capa de \(anime.displayTitle)")
            
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(anime.displayTitle)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Metadata
                HStack(spacing: 12) {
                    // Score
                    Label(anime.formattedScore, systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .accessibilityLabel("Nota: \(anime.formattedScore)")
                    
                    // Popularity
                    Label(anime.formattedPopularity, systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                        .accessibilityLabel("Popularidade: \(anime.formattedPopularity)")
                    
                    // Episodes
                    if anime.episodes != nil {
                        Label(anime.formattedEpisodes, systemImage: "tv")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .accessibilityLabel("\(anime.formattedEpisodes) episódios")
                    }
                }
                
                // Year
                if !anime.formattedYear.isEmpty {
                    Text(anime.formattedYear)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}