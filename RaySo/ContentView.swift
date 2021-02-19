//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

enum Colors: String, CaseIterable {
    
    case candy, breeze, midnight, sunset
}

enum Padding: Int, CaseIterable {
    
    case small = 16
    case medium = 32
    case normal = 64
    case large = 128
}

struct ContentView: View {
    
    private static let defaults = UserDefaults(suiteName: Constants.suiteName)!
    
    @AppStorage(Constants.colorKey, store: Self.defaults)
    var color: Colors = .midnight
    
    @AppStorage(Constants.backgroundKey, store: Self.defaults)
    var background: Bool = true
    
    @AppStorage(Constants.darkModeKey, store: Self.defaults)
    var darkMode: Bool = true
    
    @AppStorage(Constants.paddingKey, store: Self.defaults)
    var padding: Padding = .normal
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Text("This app contains Xcode Source Editor Extension that allows you to share your code via ray.so. Just select your code and click Editor > ray.so > Share")
            Picker("", selection: $color) {
                ForEach(Colors.allCases, id: \.self) { color in
                    Text(color.rawValue.capitalized)
                        .font(.caption)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            HStack {
                Text("Background")
                Spacer()
                Toggle("", isOn: $background)
            }
            HStack {
                Text("Dark Mode")
                Spacer()
                Toggle("", isOn: $darkMode)
            }
            Picker("", selection: $padding) {
                ForEach(Padding.allCases, id: \.self) { color in
                    Text("\(color.rawValue)")
                        .font(.caption)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 16)
            Button("Visit the project on Github") {
                let url = URL(string: "https://github.com/artemnovichkov/RaySo")!
                openURL(url)
            }
        }
        .padding()
        .onAppear {
            Self.defaults.register(defaults: [Constants.colorKey: Colors.midnight.rawValue,
                                              Constants.backgroundKey: true,
                                              Constants.darkModeKey: true,
                                              Constants.paddingKey: Padding.normal.rawValue])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
