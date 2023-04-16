import Foundation

struct Metadata: Codable {
    let title: String
    let keywords: [String]
    let description: String
    
    static func load(filename: String) async throws -> Metadata {
        let fileURL = URL(fileURLWithPath: filename)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Metadata.self, from: data)
    }
}
