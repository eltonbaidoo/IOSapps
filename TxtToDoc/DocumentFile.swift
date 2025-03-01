import Foundation
import UniformTypeIdentifiers

struct DocumentFile {
    let url: URL
    
    var filename: String {
        url.lastPathComponent
    }
}

enum ExportFormat {
    case pdf
    case txt
} 