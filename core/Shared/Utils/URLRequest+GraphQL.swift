import Foundation

extension URLRequest {
    static func graphQL(query: String, variables: [String: Any]? = nil) -> URLRequest? {
        guard let url = URL(string: "https://graphql.anilist.co") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var body: [String: Any] = ["query": query]
        if let variables = variables {
            body["variables"] = variables
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            return nil
        }
        
        return request
    }
}