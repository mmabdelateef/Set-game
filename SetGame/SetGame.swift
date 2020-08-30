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
        guard let cardIdx = cardsOnTable.firstIndex(where: { $0?.id == card.id }) else {
            assertionFailure("Card must be on table to be selected")
            return
        }

        cardsOnTable[cardIdx]?.isSelected.toggle()
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
