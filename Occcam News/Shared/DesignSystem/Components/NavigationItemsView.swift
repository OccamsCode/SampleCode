//
//  NavigationItemsView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 18/12/2023.
//

import SwiftUI

struct NavigationItemsView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var selection: NewsCategory
    var buttonAction: () -> Void
    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            Button(action: buttonAction) {
                Image(systemName: "arrow.clockwise")
            }
        default:
            NewsCategorySelectionView(selection: $selection)
        }
    }
}

struct NavigationItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationItemsView(selection: .constant(.business)) {}
    }
}
