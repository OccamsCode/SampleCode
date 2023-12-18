//
//  NewsCategorySelectionView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 18/12/2023.
//

import SwiftUI

struct NewsCategorySelectionView: View {
    @Binding var selection: NewsCategory
    var body: some View {
        Menu {
            Picker("Category", selection: $selection) {
                ForEach(NewsCategory.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .imageScale(.large)
        }
    }
}

struct NewsCategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NewsCategorySelectionView(selection: .constant(.health))
    }
}
