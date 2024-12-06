//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

enum Padding: Int, CaseIterable {
    
    case small = 16
    case medium = 32
    case normal = 64
    case large = 128
}

struct ContentView: View {
    
    private static let defaults = UserDefaults(suiteName: Constants.suiteName)!

    @AppStorage(Constants.themeKey, store: Self.defaults)
    var theme: Theme = .candy

    @AppStorage(Constants.backgroundKey, store: Self.defaults)
    var background: Bool = true
    
    @AppStorage(Constants.darkModeKey, store: Self.defaults)
    var darkMode: Bool = true
    
    @AppStorage(Constants.paddingKey, store: Self.defaults)
    var padding: Padding = .normal
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Text("This app contains Xcode Source Editor Extension that allows you to share your code via [ray.so](https://ray.so/). Just select your code and click Editor > ray.so > Share")
                .font(.title3)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
            HStack(alignment: .top, spacing: 48) {
                VStack(alignment: .leading) {
                    Text("Theme")
                    Picker("", selection: $theme) {
                        Section(content: {
                            ForEach(Theme.allCases, id: \.self) { theme in
                                theme
                                if theme == .clerk {
                                    Divider()
                                }
                            }
                        }, header: {
                            Text("Partners")
                                .font(.caption)
                        })
                    }
                }
                VStack(alignment: .leading) {
                    Text("Background")
                    Toggle("", isOn: $background)
                        .toggleStyle(.switch)
                }
                VStack(alignment: .leading) {
                    Text("Dark Mode")
                    Toggle("", isOn: $darkMode)
                        .toggleStyle(.switch)
                }
                VStack(alignment: .leading) {
                    Text("Padding")
                    Picker("", selection: $padding) {
                        ForEach(Padding.allCases, id: \.self) { color in
                            Text("\(color.rawValue)")
                                .font(.caption)
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 16)
            }
            Button("Visit the project on Github") {
                let url = URL(string: "https://github.com/artemnovichkov/RaySo")!
                openURL(url)
            }
        }
        .padding()
        .onAppear {
            Self.defaults.register(defaults: [Constants.themeKey: Theme.candy.rawValue,
                                              Constants.backgroundKey: true,
                                              Constants.darkModeKey: true,
                                              Constants.paddingKey: Padding.normal.rawValue])
        }
    }
}

#Preview {
    ContentView()
}
