import Foundation

class SystemUtils {
    static func getMarkdownFilesRecursive(at path: String, withExtension ext: String) throws -> [String] {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: path)
        
        func recursiveDirectoryContents(at url: URL) throws -> [String] {
            let directoryContents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            
            var files = [String]()
            
            for fileOrFolder in directoryContents {
                if fileOrFolder.hasDirectoryPath { // folder
                    let subdirectoryFiles = try recursiveDirectoryContents(at: fileOrFolder)
                    files.append(contentsOf: subdirectoryFiles)
                } else { // file
                    if fileOrFolder.path.description.hasSuffix(ext) {
                        files.append(fileOrFolder.path)
                    }
                }
            }
            
            return files
        }
        
        let files = try recursiveDirectoryContents(at: url)
        return files
    }
    //  let contents = try await loadFileContents(atPath: filePath)
    //  print("File contents:")
    //  print(contents)
    static func loadFileContents(atPath path: String) async throws -> String {
        let fileURL = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: fileURL)
        guard let contents = String(data: data, encoding: .utf8) else {
            throw "Couldn't load content of file"
        }
        return contents
    }
    
    //  try await saveFileContents(stringToSave, atPath: filePath)
    static func saveFileContents(_ string: String, atPath path: String) async throws {
        guard let data = string.data(using: .utf8) else {
            throw "Couldn't save content of file"
        }
        let fileURL = URL(fileURLWithPath: path)
        try data.write(to: fileURL)
    }
    
    static func getFolder(atPath path: String) -> String {
        let comp = path.components(separatedBy: "/")
        let newcomp = comp.dropLast()
        return newcomp.joined(separator: "/") + "/"
    }
    
    static func getFile(atPath path: String) -> String {
        let comp = path.components(separatedBy: "/")
        return comp.last!
    }
}
