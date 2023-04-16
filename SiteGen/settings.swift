import Foundation

struct Settings: Codable {
    let workdir: String
    let template: String
    let contenttag: String
    let titletag: String
    let descriptiontag: String
    let keywordstag: String
    let metadatafilename: String
    
    static func load(filename: String) async throws -> Settings {
        let fileURL = URL(fileURLWithPath: filename)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Settings.self, from: data)
    }
}
