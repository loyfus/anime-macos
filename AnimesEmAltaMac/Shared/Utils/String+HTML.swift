import Foundation

extension String {
    func cleanedFromHTML() -> String {
        var result = self
        
        // Remove HTML tags
        result = result.replacingOccurrences(of: "<br>", with: "\n", options: .caseInsensitive)
        result = result.replacingOccurrences(of: "<br/>", with: "\n", options: .caseInsensitive)
        result = result.replacingOccurrences(of: "<br />", with: "\n", options: .caseInsensitive)
        result = result.replacingOccurrences(of: "</p>", with: "\n\n", options: .caseInsensitive)
        result = result.replacingOccurrences(of: "<p>", with: "", options: .caseInsensitive)
        
        // Remove all other HTML tags
        let htmlTagPattern = "<[^>]+>"
        if let regex = try? NSRegularExpression(pattern: htmlTagPattern, options: .caseInsensitive) {
            result = regex.stringByReplacingMatches(
                in: result,
                options: [],
                range: NSRange(location: 0, length: result.utf16.count),
                withTemplate: ""
            )
        }
        
        // Decode HTML entities
        let entities = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&#39;": "'",
            "&apos;": "'",
            "&nbsp;": " ",
            "&ndash;": "–",
            "&mdash;": "—",
            "&hellip;": "...",
            "&copy;": "©",
            "&reg;": "®",
            "&trade;": "™"
        ]
        
        for (entity, replacement) in entities {
            result = result.replacingOccurrences(of: entity, with: replacement)
        }
        
        // Clean up multiple newlines
        while result.contains("\n\n\n") {
            result = result.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        
        // Trim whitespace
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return result
    }
}