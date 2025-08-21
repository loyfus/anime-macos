import XCTest
@testable import AnimesEmAltaMac

final class URLRequestGraphQLTests: XCTestCase {
    
    func testGraphQLRequestCreation() throws {
        let query = "query { test }"
        let request = URLRequest.graphQL(query: query)
        
        XCTAssertNotNil(request)
        
        guard let request = request else {
            XCTFail("Request should not be nil")
            return
        }
        
        XCTAssertEqual(request.url?.absoluteString, "https://graphql.anilist.co")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
        
        // Check body
        XCTAssertNotNil(request.httpBody)
        
        if let body = request.httpBody,
           let bodyDict = try? JSONSerialization.jsonObject(with: body) as? [String: Any] {
            XCTAssertEqual(bodyDict["query"] as? String, query)
            XCTAssertNil(bodyDict["variables"])
        } else {
            XCTFail("Body should be valid JSON")
        }
    }
    
    func testGraphQLRequestWithVariables() throws {
        let query = "query ($page: Int) { Page(page: $page) { media { id } } }"
        let variables: [String: Any] = ["page": 1, "perPage": 20]
        let request = URLRequest.graphQL(query: query, variables: variables)
        
        XCTAssertNotNil(request)
        
        guard let request = request else {
            XCTFail("Request should not be nil")
            return
        }
        
        // Check body contains variables
        XCTAssertNotNil(request.httpBody)
        
        if let body = request.httpBody,
           let bodyDict = try? JSONSerialization.jsonObject(with: body) as? [String: Any] {
            XCTAssertEqual(bodyDict["query"] as? String, query)
            XCTAssertNotNil(bodyDict["variables"])
            
            if let vars = bodyDict["variables"] as? [String: Any] {
                XCTAssertEqual(vars["page"] as? Int, 1)
                XCTAssertEqual(vars["perPage"] as? Int, 20)
            } else {
                XCTFail("Variables should be present in body")
            }
        } else {
            XCTFail("Body should be valid JSON")
        }
    }
    
    func testGraphQLRequestHeaders() {
        let request = URLRequest.graphQL(query: "query { test }")
        
        XCTAssertNotNil(request)
        
        guard let request = request else {
            XCTFail("Request should not be nil")
            return
        }
        
        // Check all required headers are set
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }
    
    func testGraphQLRequestMethod() {
        let request = URLRequest.graphQL(query: "query { test }")
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "POST")
    }
    
    func testGraphQLRequestURL() {
        let request = URLRequest.graphQL(query: "query { test }")
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://graphql.anilist.co")
    }
    
    func testComplexVariables() throws {
        let variables: [String: Any] = [
            "page": 2,
            "perPage": 50,
            "sort": "TRENDING_DESC",
            "type": "ANIME",
            "filters": [
                "year": 2024,
                "season": "WINTER"
            ]
        ]
        
        let request = URLRequest.graphQL(query: "complex query", variables: variables)
        
        XCTAssertNotNil(request)
        
        guard let request = request,
              let body = request.httpBody,
              let bodyDict = try? JSONSerialization.jsonObject(with: body) as? [String: Any],
              let vars = bodyDict["variables"] as? [String: Any] else {
            XCTFail("Should create valid request with complex variables")
            return
        }
        
        XCTAssertEqual(vars["page"] as? Int, 2)
        XCTAssertEqual(vars["perPage"] as? Int, 50)
        XCTAssertEqual(vars["sort"] as? String, "TRENDING_DESC")
        XCTAssertEqual(vars["type"] as? String, "ANIME")
        
        if let filters = vars["filters"] as? [String: Any] {
            XCTAssertEqual(filters["year"] as? Int, 2024)
            XCTAssertEqual(filters["season"] as? String, "WINTER")
        } else {
            XCTFail("Filters should be present")
        }
    }
}