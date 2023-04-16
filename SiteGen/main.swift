import Foundation
import cmark_gfm_swift // md to html


// TODO 404 page
func main() async {
    var settingsFile = ".settings.json"
    let start = CFAbsoluteTimeGetCurrent()
    if CommandLine.arguments.count > 1 {
        settingsFile = CommandLine.arguments.last!
    }
    do {
        let cfg = try await Settings.load(filename: settingsFile)
        let files = try SystemUtils.getMarkdownFilesRecursive(at: cfg.workdir, withExtension: ".md")
        let pageTemplate = try await SystemUtils.loadFileContents(atPath: cfg.template)
        
        try await files.asyncForEach { file in
            print("Found \t\t\(file)")
            let markdown = try await SystemUtils.loadFileContents(atPath: file)
            guard let htmlContent = Node(markdown: markdown, extensions: [.table])?.html else {
                print("Error: no html produced for file")
                return
            }
            
            var templatedHTML = pageTemplate.replacingOccurrences(of: cfg.contenttag, with: htmlContent)
            templatedHTML = TextUtils.cleanupMarkdownHTMLConversion(html: templatedHTML)
            templatedHTML = try TextUtils.prettyPrint(html: templatedHTML)
            
            let folder = SystemUtils.getFolder(atPath: file)
            
            // metadata
            let metadatafile = folder + cfg.metadatafilename
            let metadata = try await Metadata.load(filename: metadatafile)
            templatedHTML = templatedHTML.replacingOccurrences(of: cfg.titletag, with: metadata.title)
            templatedHTML = templatedHTML.replacingOccurrences(of: cfg.descriptiontag, with: metadata.description)
            templatedHTML = templatedHTML.replacingOccurrences(of: cfg.keywordstag, with: metadata.keywords.joined(separator: ", "))
            
            print("Processed \t\(folder + "index.html")")
            try await SystemUtils.saveFileContents(templatedHTML, atPath: folder + "index.html")
        }
    } catch {
        print("Error: \(error)")
    }
    let end = round((CFAbsoluteTimeGetCurrent() - start) * 1000)
    print("Completed in \(end) ms")
}

await main()
