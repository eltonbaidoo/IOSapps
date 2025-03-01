import SwiftUI
import QuickLook
import UIKit
import ZIPFoundation
import WebKit
import Foundation

struct DocumentExportView: UIViewControllerRepresentable {
    let document: DocumentFile
    let exportFormat: ExportFormat
    @Binding var conversionError: String?
    @Binding var isConverting: Bool
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentExportView
        
        init(_ parent: DocumentExportView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.isConverting = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        isConverting = true
        let exportURL = prepareExportFile()
        let picker = UIDocumentPickerViewController(forExporting: [exportURL])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    private func prepareExportFile() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let exportFilename = document.url.deletingPathExtension().lastPathComponent
        
        switch exportFormat {
        case .pdf:
            return convertToPDF(tempDir: tempDir, filename: exportFilename)
        case .txt:
            return convertToTXT(tempDir: tempDir, filename: exportFilename)
        }
    }
    
    private func handleError(_ error: Error, operation: String) {
        let errorMessage = "Error \(operation): \(error.localizedDescription)"
        DispatchQueue.main.async {
            self.conversionError = errorMessage
            self.isConverting = false
        }
    }
    
    private func convertToPDF(tempDir: URL, filename: String) -> URL {
        let pdfURL = tempDir.appendingPathComponent("\(filename).pdf")
        let workDir = tempDir.appendingPathComponent(UUID().uuidString)
        
        do {
            try FileManager.default.createDirectory(at: workDir, withIntermediateDirectories: true)
            try FileManager.default.unzipItem(at: document.url, to: workDir)
            
            let documentXML = workDir.appendingPathComponent("word/document.xml")
            let xmlData = try Data(contentsOf: documentXML)
            let content = try extractTextFromXML(xmlData)
            
            let htmlContent = """
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body { font-family: -apple-system, sans-serif; line-height: 1.6; }
                    p { margin: 1em 0; }
                </style>
            </head>
            <body>
            \(content)
            </body>
            </html>
            """
            
            let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 612, height: 792))
            webView.loadHTMLString(htmlContent, baseURL: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let pdfData = webView.createPDF()
                do {
                    try pdfData.write(to: pdfURL)
                } catch {
                    handleError(error, operation: "saving PDF")
                }
            }
        } catch {
            handleError(error, operation: "converting to PDF")
        }
        
        return pdfURL
    }
    
    private func convertToTXT(tempDir: URL, filename: String) -> URL {
        let txtURL = tempDir.appendingPathComponent("\(filename).txt")
        
        do {
            let workDir = tempDir.appendingPathComponent(UUID().uuidString)
            try FileManager.default.createDirectory(at: workDir, withIntermediateDirectories: true)
            try FileManager.default.unzipItem(at: document.url, to: workDir)
            
            let documentXML = workDir.appendingPathComponent("word/document.xml")
            let xmlData = try Data(contentsOf: documentXML)
            let content = try extractTextFromXML(xmlData)
            
            try content.write(to: txtURL, atomically: true, encoding: .utf8)
        } catch {
            handleError(error, operation: "converting to TXT")
        }
        
        return txtURL
    }
    
    private func extractTextFromXML(_ xmlData: Data) throws -> String {
        let xml = try XMLDocument(data: xmlData)
        let paragraphs = try xml.nodes(forXPath: "//w:p")
        
        return paragraphs.compactMap { paragraph in
            let texts = try? paragraph.nodes(forXPath: ".//w:t")
            return texts?.compactMap { $0.stringValue }.joined(separator: " ")
        }.joined(separator: "\n")
    }
}

extension WKWebView {
    func createPDF() -> Data {
        let config = WKPDFConfiguration()
        let pdfData = try? self.pdf(configuration: config)
        return pdfData ?? Data()
    }
} 