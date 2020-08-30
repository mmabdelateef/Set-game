//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Mostafa Abdellateef on 28/08/2020.
//

import Foundation


class SetGameViewModel: ObservableObject {
    private var model: SetGameModel {
        didSet {
            self.cardsOnTable = model.cardsOnTable
        }
    }

    @Published var cardsOnTable: [Card?] = []

    init() {
        model = SetGameModel()
        populateTable()
    }

    func populateTable() {
        model.populateTable()
    }

    // MARK: - Intent(s)

    func select(card: Card) {
        model.select(card: card)
    }
}
