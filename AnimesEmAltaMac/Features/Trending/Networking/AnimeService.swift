import Foundation

actor AnimeService {
    static let shared = AnimeService()
    
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    private init() {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 10 * 1024 * 1024,  // 10 MB
            diskCapacity: 50 * 1024 * 1024,     // 50 MB
            diskPath: nil
        )
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.urlSession = URLSession(configuration: config)
    }
    
    // MARK: - Queries
    
    private let trendingQuery = """
    query ($page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        media(type: ANIME, sort: TRENDING_DESC) {
          id
          title {
            romaji
            english
            native
          }
          coverImage {
            medium
            large
            extraLarge
          }
          averageScore
          popularity
          episodes
          seasonYear
          trailer {
            id
            site
            thumbnail
          }
          streamingEpisodes {
            title
            thumbnail
            url
            site
          }
          externalLinks {
            id
            url
            site
            type
            icon
            color
          }
        }
      }
    }
    """
    
    private let descriptionQuery = """
    query ($id: Int) {
      Media(id: $id, type: ANIME) {
        id
        title {
          romaji
          english
          native
        }
        coverImage {
          medium
          large
          extraLarge
        }
        averageScore
        popularity
        episodes
        seasonYear
        description(asHtml: false)
        trailer {
          id
          site
          thumbnail
        }
        streamingEpisodes {
          title
          thumbnail
          url
          site
        }
        externalLinks {
          id
          url
          site
          type
          icon
          color
        }
      }
    }
    """
    
    // MARK: - Public Methods
    
    func fetchTrending(page: Int, perPage: Int = 20) async throws -> [Anime] {
        let variables: [String: Any] = [
            "page": page,
            "perPage": perPage
        ]
        
        guard let request = URLRequest.graphQL(query: trendingQuery, variables: variables) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            let graphQLResponse = try decoder.decode(GraphQLResponse.self, from: data)
            return graphQLResponse.data.Page?.media ?? []
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    func fetchDescription(id: Int) async throws -> String? {
        let variables: [String: Any] = ["id": id]
        
        guard let request = URLRequest.graphQL(query: descriptionQuery, variables: variables) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            let graphQLResponse = try decoder.decode(GraphQLResponse.self, from: data)
            return graphQLResponse.data.Media?.description?.cleanedFromHTML()
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}