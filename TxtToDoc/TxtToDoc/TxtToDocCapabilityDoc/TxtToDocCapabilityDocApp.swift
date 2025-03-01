//
//  TxtToDocCapabilityDocApp.swift
//  TxtToDocCapabilityDoc
//
//  Created by Elton Baidoo on 2/28/25.
//

import SwiftUI

@main
struct TxtToDocCapabilityDocApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: TxtToDocCapabilityDocDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
