//
//  SwiftConcurrencyApp.swift
//  SwiftConcurrency
//
//  Created by Darie-Nistor Nicolae on 09.04.2023.
//

import SwiftUI

@main
struct SwiftConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            DownloadImageAsync()
        }
    }
}
