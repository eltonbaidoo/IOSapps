//
//  ContentView.swift
//  TxtToDocCapabilityDoc
//
//  Created by Elton Baidoo on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: TxtToDocCapabilityDocDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(TxtToDocCapabilityDocDocument()))
}
