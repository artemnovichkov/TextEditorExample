//
//  Created by Artem Novichkov on 17.11.2024.
//

import SwiftUI

extension View {

    func characterLimit(_ text: Binding<String>, to limit: Int) -> some View {
        onChange(of: text.wrappedValue) {
            text.wrappedValue = String(text.wrappedValue.prefix(limit))
        }
    }
}
