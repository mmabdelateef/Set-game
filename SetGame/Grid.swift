//
//  Grid.swift
//  Memorize
//
//  Created by Mostafa Abdellateef on 12/08/2020.
//  Copyright © 2020 Mostafa Abdellateef. All rights reserved.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {

    private var items: [Item]
    private var viewForItem: (Item) -> ItemView

    init(_ items: [Item], @ViewBuilder viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }

    var body: some View {
        GeometryReader { geometry in
            let layout = GridLayout(itemCount: items.count, in: geometry.size)
            ForEach(items) { item in
                // Didn't need a Group here for conditional views
                if let itemIdx = index(of: item) {
                    viewForItem(item)
                        .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                        .position(layout.location(ofItemAt: itemIdx))

                }
            }
        }
    }

    private func index(of item: Item) -> Int? {
        items.firstIndex(where: { $0.id == item.id} )
    }
}
