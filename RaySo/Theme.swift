//
//  Created by Artem Novichkov on 06.12.2024.
//

import SwiftUI

enum Theme: String, CaseIterable {

    case vercel
    case supabase
    case tailwind
    case openAI
    case mintlify
    case prisma
    case clerk

    case bitmap
    case noir
    case ice
    case sand
    case forest
    case mono
    case breeze
    case candy
    case crimson
    case falcon
    case meadow
    case midnight
    case raindrop
    case sunset
}

extension Theme: View {

    var body: some View {
        Text(rawValue.capitalized)
            .font(.caption)
    }
}
