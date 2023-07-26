//
//  BalancedApp.swift
//
//
//  Created by Patrick Bien on 23.01.22.
//  powered by codingstudios

import SwiftUI

@main
struct BalancedApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var bank = Bank()
    
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.dark)
                .environmentObject(bank)
        }.onChange(of: scenePhase) { phase in
            print("phase change \(phase)")
         }
    }
}



