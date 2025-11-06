//
//  ContentView.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 5/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    var body: some View {
        Group {
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else {
                MainMenuView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
