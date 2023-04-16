import Foundation
// https://github.com/cntrump/cmark-gfm-swift/tree/pr_swiftpm_support
// https://github.com/cntrump/cmark-gfm-swift.git
import cmark_gfm_swift // md to html
import SwiftSoup // html pretty formatting

class TextUtils {
    
    // OPTIONAL Remove all THEAD content left over from github flavoured markdown conversion, we don't want empty headers <tr><th>
    // but we did need to define theads in Markdown templates, or the parser would not see tables!
    // OPTIONAL clear up the unecessary <td align="left"> to <td>
    static func cleanupMarkdownHTMLConversion(html: String) -> String {
        var thtml = html
        while let theadStartRange = thtml.range(of: "<thead>"), let theadEndRange = thtml.range(of: "</thead>") {
            let removalRange = theadStartRange.lowerBound..<theadEndRange.upperBound
            thtml.replaceSubrange(removalRange, with: "")
        }
        thtml = thtml.replacingOccurrences(of: "<td align=\"left\">", with: "<td>")
        return thtml
    }
    
    // OPTIONAL prettyfiy the HTML before saving it.
    static func prettyPrint(html: String) throws -> String {
        var thtml = html
        do {
            let document = try SwiftSoup.parse(thtml)
            thtml = try document.outputSettings(OutputSettings().prettyPrint(pretty: true)).html()
            let regexPattern = "(?<=^|\\n)  " // prettyPrint only uses 2 spaces, we want 4!
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let range = NSRange(thtml.startIndex..<thtml.endIndex, in: thtml)
            thtml = regex.stringByReplacingMatches(in: thtml, options: [], range: range, withTemplate: "    ")
        } catch {
            print("Error Prettyfiying (OPTIONAL STEP): \(error.localizedDescription)")
        }
        return thtml
    }

}
