import SwiftUI

struct AnimeRow: View {
    let anime: Anime
    
    var body: some View {
        HStack(spacing: 12) {
            // Cover Image minimal
            AsyncImage(url: URL(string: anime.coverImage.medium ?? "")) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.12))
                        .overlay(ProgressView().scaleEffect(0.6))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.12))
                        .overlay(Image(systemName: "photo").foregroundColor(.gray))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 64, height: 96)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .accessibilityLabel("Capa de \(anime.displayTitle)")

            VStack(alignment: .leading, spacing: 4) {
                // Título
                Text(anime.displayTitle)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Metadados condensados
                HStack(spacing: 8) {
                    Label(anime.formattedScore, systemImage: "star.fill")
                        .foregroundColor(.secondary)
                    if let _ = anime.episodes {
                        Text("•")
                            .foregroundColor(.secondary)
                        Label(anime.formattedEpisodes + " eps", systemImage: "tv")
                            .foregroundColor(.secondary)
                    }
                    if !anime.formattedYear.isEmpty {
                        Text("•")
                            .foregroundColor(.secondary)
                        Label(anime.formattedYear, systemImage: "calendar")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.caption)
            }

            Spacer()
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}
