//
//  SetGame.swift
//  SetGame
//
//  Created by Mostafa Abdellateef on 28/08/2020.
//

import Foundation

enum CardShape: Int, CaseIterable {
    case diamond, squiggle, oval
}

enum Color: Int, CaseIterable {
    case red, blue, purple
}

enum ShapeCount: Int, CaseIterable {
    case one = 1, two = 2, three = 3
}

enum Shading: Int, CaseIterable {
    case solid, striped, open
}

struct Card: Identifiable {
    var id: String {
        "\(color) \(shape) \(count) \(shading)"
    }

    var color: Color
    var shape: CardShape
    var count: ShapeCount
    var shading: Shading

    var isSelected: Bool = false
    var isMatch = false
    var isMissMatch = false
}

extension Card: CustomStringConvertible {
    var description: String {
        "\(color) \(shape) \(count) \(shading)"
    }
}

struct SetGameModel {
    private static let maxNumberOfCardsOnTable = 12
    private var cards: [Card]

    private(set) var cardsOnTable: [Card?] = Array(repeating: nil, count: SetGameModel.maxNumberOfCardsOnTable)

    init() {
        var cards = [Card]()
        for shape in CardShape.allCases {
            for color in Color.allCases {
                for count in ShapeCount.allCases {
                    for shading in Shading.allCases {
                        cards.append(Card(color: color, shape: shape, count: count, shading: shading))
                    }
                }
            }
        }
        self.cards = cards.shuffled()
    }

    mutating func populateTable() {
        cardsOnTable = cardsOnTable.map { if $0 == nil {
            return cards.popLast()
        }
        return nil
        }
    }

    mutating func select(card: Card) {
        let alreadySelectedCards = cardsOnTable.compactMap { $0 }
            .filter { $0.isSelected }

        if alreadySelectedCards.count == 3 {
            // three cards already selected on table.
            // if match, move to matched cards and deal three new cards
            // if mismatch, deselect
            let cardsIndices: [Int] = alreadySelectedCards.map { card in
                cardsOnTable.firstIndex(where: { $0?.id == card.id })!
            }

            if alreadySelectedCards.allSatisfy({ $0.isMatch }) {
                cardsIndices.forEach {
                    cardsOnTable[$0] = nil
                }
            } else if alreadySelectedCards.allSatisfy({ $0.isMissMatch }) {
                cardsIndices.forEach {
                    cardsOnTable[$0]?.isSelected = false
                    cardsOnTable[$0]?.isMatch = false
                    cardsOnTable[$0]?.isMissMatch = false
                }
            } else {
                assertionFailure("Must be match or mismatch")
            }
        }

        guard let cardIdx = cardsOnTable.firstIndex(where: { $0?.id == card.id }) else {
            assertionFailure("Card must be on table to be selected")
            return
        }
        cardsOnTable[cardIdx]?.isSelected.toggle()

        let selectedCards = cardsOnTable.compactMap { $0 }
            .filter { $0.isSelected }

        checkSet(cards: selectedCards)
    }

    private mutating func checkSet(cards: [Card]) {
        let cardsIndices: [Int] = cards.map { card in
            cardsOnTable.firstIndex(where: { $0?.id == card.id })!
        }

        if cards.count < 3 {
            cardsIndices.forEach {
                cardsOnTable[$0]?.isMatch = false
                cardsOnTable[$0]?.isMissMatch = false
            }
        } else {
            let isMatch = cards.isSet
            cardsIndices.forEach {
                cardsOnTable[$0]?.isMatch = isMatch
                cardsOnTable[$0]?.isMissMatch = !isMatch
            }
        }

    }
}

extension Array where Element == Card {
    var isSet: Bool {
        guard count == 3 else { return false } // must be three cards

        let first = self[0], second = self[1], third = self[2]

        let isSameColor = first.color == second.color && first.color == third.color
        let isSameShape = first.shape == second.shape && first.shape == third.shape
        let isSameCount = first.count == second.count && first.count == third.count
        let isSameShading = first.shading == second.shading && first.shading == third.shading

        return [isSameColor, isSameShape, isSameCount, isSameShading].filter { $0 }.count == 1
    }
}
