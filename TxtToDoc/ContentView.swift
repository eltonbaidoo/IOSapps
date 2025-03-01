import SwiftUI
import UniformTypeIdentifiers
import QuickLook

struct ContentView: View {
    @State private var isFilePickerPresented = false
    @State private var selectedDocument: DocumentFile?
    @State private var showExportSheet = false
    @State private var exportFormat: ExportFormat = .pdf
    @State private var conversionError: String?
    @State private var isConverting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Main content area
                if let document = selectedDocument {
                    VStack(spacing: 15) {
                        Text("Selected file: \(document.filename)")
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                exportFormat = .pdf
                                showExportSheet = true
                            }) {
                                Label("Export as PDF", systemImage: "doc.fill")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                exportFormat = .txt
                                showExportSheet = true
                            }) {
                                Label("Export as TXT", systemImage: "doc.text.fill")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(isConverting)
                    }
                }
                
                // Select File Button
                Button(action: {
                    isFilePickerPresented = true
                }) {
                    Label("Select DOCX File", systemImage: "doc.badge.plus")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(isConverting)
                
                // Progress and Error Messages
                if isConverting {
                    ProgressView("Converting...")
                        .padding()
                }
                
                if let error = conversionError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("DOCX Converter")
            .fileImporter(
                isPresented: $isFilePickerPresented,
                allowedContentTypes: [UTType("org.openxmlformats.wordprocessingml.document")!],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    selectedDocument = DocumentFile(url: url)
                    print("Selected file: \(url.lastPathComponent)")
                    conversionError = nil
                case .failure(let error):
                    conversionError = "Error selecting file: \(error.localizedDescription)"
                    print("File selection error: \(error)")
                }
            }
            .sheet(isPresented: $showExportSheet) {
                if let document = selectedDocument {
                    DocumentExportView(
                        document: document,
                        exportFormat: exportFormat,
                        conversionError: $conversionError,
                        isConverting: $isConverting
                    )
                }
            }
        }
    }
}

// Preview provider for SwiftUI canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 