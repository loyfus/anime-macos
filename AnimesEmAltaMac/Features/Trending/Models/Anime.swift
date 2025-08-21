import Foundation

// MARK: - GraphQL Response Models

struct GraphQLResponse: Codable {
    let data: GraphQLData
}

struct GraphQLData: Codable {
    let Page: Page?
    let Media: Anime?
}

struct Page: Codable {
    let media: [Anime]
}

// MARK: - Anime Model

struct Anime: Codable, Identifiable, Hashable {
    let id: Int
    let title: Title
    let coverImage: CoverImage
    let averageScore: Int?
    let popularity: Int?
    let episodes: Int?
    let seasonYear: Int?
    let description: String?
    let trailer: Trailer?
    let streamingEpisodes: [StreamingEpisode]?
    let externalLinks: [ExternalLink]?
    
    var displayTitle: String {
        title.english ?? title.romaji ?? title.native ?? "Sem título"
    }
    
    var formattedScore: String {
        guard let score = averageScore else { return "N/A" }
        return String(format: "%.1f", Double(score) / 10.0)
    }
    
    var formattedPopularity: String {
        guard let popularity = popularity else { return "N/A" }
        if popularity >= 1_000_000 {
            return String(format: "%.1fM", Double(popularity) / 1_000_000)
        } else if popularity >= 1_000 {
            return String(format: "%.1fK", Double(popularity) / 1_000)
        }
        return "\(popularity)"
    }
    
    var formattedEpisodes: String {
        guard let episodes = episodes else { return "N/A" }
        return "\(episodes)"
    }
    
    var formattedYear: String {
        guard let year = seasonYear else { return "" }
        return "\(year)"
    }
    
    var aniListURL: URL {
        URL(string: "https://anilist.co/anime/\(id)")!
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Anime, rhs: Anime) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Supporting Models

struct Title: Codable, Hashable {
    let romaji: String?
    let english: String?
    let native: String?
}

struct CoverImage: Codable, Hashable {
    let medium: String?
    let large: String?
    let extraLarge: String?
    
    var bestAvailable: String? {
        extraLarge ?? large ?? medium
    }
}

// MARK: - Trailer Model

struct Trailer: Codable, Hashable {
    let id: String?
    let site: String?
    let thumbnail: String?
    
    var url: URL? {
        guard let id = id, let site = site else { return nil }
        switch site.lowercased() {
        case "youtube":
            return URL(string: "https://www.youtube.com/watch?v=\(id)")
        case "dailymotion":
            return URL(string: "https://www.dailymotion.com/video/\(id)")
        default:
            return nil
        }
    }
    
    var embedURL: URL? {
        guard let id = id, let site = site else { return nil }
        switch site.lowercased() {
        case "youtube":
            return URL(string: "https://www.youtube.com/embed/\(id)")
        case "dailymotion":
            return URL(string: "https://www.dailymotion.com/embed/video/\(id)")
        default:
            return nil
        }
    }
}

// MARK: - Streaming Models

struct StreamingEpisode: Codable, Hashable {
    let title: String?
    let thumbnail: String?
    let url: String?
    let site: String
}

struct ExternalLink: Codable, Hashable {
    let id: Int
    let url: String
    let site: String
    let type: String?
    let icon: String?
    let color: String?
    
    var isStreamingService: Bool {
        let streamingServices = ["Crunchyroll", "Netflix", "Hulu", "Amazon Prime Video", 
                                "Funimation", "Disney Plus", "HBO Max", "Paramount Plus",
                                "Peacock", "Apple TV Plus", "Adult Swim", "Tubi TV",
                                "PlutoTV", "Roku", "YouTube", "Bilibili", "iQIYI"]
        return streamingServices.contains(site)
    }
}