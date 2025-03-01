//
//  TxtToDocCapabilityDocuApp.swift
//  TxtToDocCapabilityDocu
//
//  Created by Elton Baidoo on 2/28/25.
//

import SwiftUI

@main
struct TxtToDocCapabilityDocuApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: TxtToDocCapabilityDocuDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
