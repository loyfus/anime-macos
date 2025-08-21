import XCTest
@testable import AnimesEmAltaMac

final class AnimeModelTests: XCTestCase {
    
    // MARK: - Test Data
    
    let sampleAnimeJSON = """
    {
        "id": 12345,
        "title": {
            "romaji": "Test Anime",
            "english": "Test Anime English",
            "native": "テストアニメ"
        },
        "coverImage": {
            "medium": "https://example.com/medium.jpg",
            "large": "https://example.com/large.jpg",
            "extraLarge": "https://example.com/extra-large.jpg"
        },
        "averageScore": 85,
        "popularity": 125000,
        "episodes": 24,
        "seasonYear": 2024,
        "description": "This is a test anime description."
    }
    """
    
    let minimalAnimeJSON = """
    {
        "id": 67890,
        "title": {
            "romaji": "Minimal Anime"
        },
        "coverImage": {}
    }
    """
    
    // MARK: - Tests
    
    func testAnimeDecoding() throws {
        let data = sampleAnimeJSON.data(using: .utf8)!
        let anime = try JSONDecoder().decode(Anime.self, from: data)
        
        XCTAssertEqual(anime.id, 12345)
        XCTAssertEqual(anime.title.english, "Test Anime English")
        XCTAssertEqual(anime.title.romaji, "Test Anime")
        XCTAssertEqual(anime.title.native, "テストアニメ")
        XCTAssertEqual(anime.coverImage.medium, "https://example.com/medium.jpg")
        XCTAssertEqual(anime.averageScore, 85)
        XCTAssertEqual(anime.popularity, 125000)
        XCTAssertEqual(anime.episodes, 24)
        XCTAssertEqual(anime.seasonYear, 2024)
        XCTAssertEqual(anime.description, "This is a test anime description.")
    }
    
    func testMinimalAnimeDecoding() throws {
        let data = minimalAnimeJSON.data(using: .utf8)!
        let anime = try JSONDecoder().decode(Anime.self, from: data)
        
        XCTAssertEqual(anime.id, 67890)
        XCTAssertEqual(anime.title.romaji, "Minimal Anime")
        XCTAssertNil(anime.title.english)
        XCTAssertNil(anime.title.native)
        XCTAssertNil(anime.coverImage.medium)
        XCTAssertNil(anime.averageScore)
        XCTAssertNil(anime.popularity)
    }
    
    func testDisplayTitle() {
        let titleWithEnglish = Title(romaji: "Romaji", english: "English", native: "Native")
        let animeWithEnglish = createAnime(title: titleWithEnglish)
        XCTAssertEqual(animeWithEnglish.displayTitle, "English")
        
        let titleWithoutEnglish = Title(romaji: "Romaji", english: nil, native: "Native")
        let animeWithoutEnglish = createAnime(title: titleWithoutEnglish)
        XCTAssertEqual(animeWithoutEnglish.displayTitle, "Romaji")
        
        let titleOnlyNative = Title(romaji: nil, english: nil, native: "Native")
        let animeOnlyNative = createAnime(title: titleOnlyNative)
        XCTAssertEqual(animeOnlyNative.displayTitle, "Native")
        
        let emptyTitle = Title(romaji: nil, english: nil, native: nil)
        let animeEmptyTitle = createAnime(title: emptyTitle)
        XCTAssertEqual(animeEmptyTitle.displayTitle, "Sem título")
    }
    
    func testFormattedScore() {
        let animeWithScore = createAnime(averageScore: 85)
        XCTAssertEqual(animeWithScore.formattedScore, "8.5")
        
        let animeWithPerfectScore = createAnime(averageScore: 100)
        XCTAssertEqual(animeWithPerfectScore.formattedScore, "10.0")
        
        let animeWithoutScore = createAnime(averageScore: nil)
        XCTAssertEqual(animeWithoutScore.formattedScore, "N/A")
    }
    
    func testFormattedPopularity() {
        let animeMillions = createAnime(popularity: 1_500_000)
        XCTAssertEqual(animeMillions.formattedPopularity, "1.5M")
        
        let animeThousands = createAnime(popularity: 50_000)
        XCTAssertEqual(animeThousands.formattedPopularity, "50.0K")
        
        let animeHundreds = createAnime(popularity: 999)
        XCTAssertEqual(animeHundreds.formattedPopularity, "999")
        
        let animeNoPopularity = createAnime(popularity: nil)
        XCTAssertEqual(animeNoPopularity.formattedPopularity, "N/A")
    }
    
    func testFormattedEpisodes() {
        let animeWithEpisodes = createAnime(episodes: 24)
        XCTAssertEqual(animeWithEpisodes.formattedEpisodes, "24")
        
        let animeNoEpisodes = createAnime(episodes: nil)
        XCTAssertEqual(animeNoEpisodes.formattedEpisodes, "N/A")
    }
    
    func testFormattedYear() {
        let animeWithYear = createAnime(seasonYear: 2024)
        XCTAssertEqual(animeWithYear.formattedYear, "2024")
        
        let animeNoYear = createAnime(seasonYear: nil)
        XCTAssertEqual(animeNoYear.formattedYear, "")
    }
    
    func testAniListURL() {
        let anime = createAnime(id: 12345)
        XCTAssertEqual(anime.aniListURL.absoluteString, "https://anilist.co/anime/12345")
    }
    
    func testCoverImageBestAvailable() {
        let fullCover = CoverImage(medium: "medium.jpg", large: "large.jpg", extraLarge: "extra.jpg")
        XCTAssertEqual(fullCover.bestAvailable, "extra.jpg")
        
        let noExtraLarge = CoverImage(medium: "medium.jpg", large: "large.jpg", extraLarge: nil)
        XCTAssertEqual(noExtraLarge.bestAvailable, "large.jpg")
        
        let onlyMedium = CoverImage(medium: "medium.jpg", large: nil, extraLarge: nil)
        XCTAssertEqual(onlyMedium.bestAvailable, "medium.jpg")
        
        let emptyCover = CoverImage(medium: nil, large: nil, extraLarge: nil)
        XCTAssertNil(emptyCover.bestAvailable)
    }
    
    // MARK: - Helper Methods
    
    private func createAnime(
        id: Int = 1,
        title: Title = Title(romaji: "Test", english: nil, native: nil),
        averageScore: Int? = nil,
        popularity: Int? = nil,
        episodes: Int? = nil,
        seasonYear: Int? = nil
    ) -> Anime {
        Anime(
            id: id,
            title: title,
            coverImage: CoverImage(medium: nil, large: nil, extraLarge: nil),
            averageScore: averageScore,
            popularity: popularity,
            episodes: episodes,
            seasonYear: seasonYear,
            description: nil
        )
    }
}