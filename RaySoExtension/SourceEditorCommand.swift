//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import XcodeKit
import Cocoa
import UniformTypeIdentifiers

final class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    enum CommandError: Swift.Error {
        case urlIsInvalid
    }
    
    private let defaults = UserDefaults(suiteName: Constants.suiteName)!
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        let code = selectedCode(from: invocation.buffer)
        let language = self.language(forContentUTI: invocation.buffer.contentUTI)
        
        guard let url = url(forCode: code, language: language) else {
            completionHandler(CommandError.urlIsInvalid)
            return
        }
        NSWorkspace.shared.open(url)
        completionHandler(nil)
    }
    
    // MARK: - Private
    
    private func url(forCode code: String, language: String) -> URL? {
        let theme = defaults.string(forKey: Constants.themeKey)
        let background = defaults.bool(forKey: Constants.backgroundKey)
        let darkMode = defaults.bool(forKey: Constants.darkModeKey)
        let padding = defaults.integer(forKey: Constants.paddingKey)
        
        let base64String = code.data(using: .utf8)?.base64EncodedString()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "ray.so"
        components.queryItems = [
            .init(name: "theme", value: theme),
            .init(name: "background", value: "\(background)"),
            .init(name: "darkMode", value: "\(darkMode)"),
            .init(name: "padding", value: "\(padding)"),
            .init(name: "title", value: "Untitled"),
            .init(name: "code", value: base64String),
            .init(name: "language", value: language)
        ]
        guard var urlString = components.string else {
            return nil
        }
        urlString = urlString.replacingOccurrences(of: "?", with: "#")
        return URL(string: urlString)
    }

    private func selectedCode(from buffer: XCSourceTextBuffer) -> String {
        var text = ""
        var spacesCount = 0
        for case let range as XCSourceTextRange in buffer.selections {
            for lineNumber in range.start.line...range.end.line {
                if lineNumber >= buffer.lines.count {
                    continue
                }
                guard let line = buffer.lines[lineNumber] as? String else {
                    continue
                }
                if spacesCount == 0 {
                    let currentSpacesCount = line.prefix(while: { $0 == " " }).count
                    if currentSpacesCount > 0 {
                        spacesCount = currentSpacesCount
                    }
                }
                let substring = line.dropFirst(spacesCount)
                text.append(String(substring))
            }
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func language(forContentUTI contentUTI: String) -> String {
        switch contentUTI {
        case UTType.swiftSource.identifier, "com.apple.dt.playground":
            "swift"
        case UTType.objectiveCSource.identifier:
            "objectivec"
        default:
            "auto"
        }
    }
}
