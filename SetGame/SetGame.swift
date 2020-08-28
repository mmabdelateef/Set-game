//
//  SetGame.swift
//  SetGame
//
//  Created by Mostafa Abdellateef on 28/08/2020.
//

import Foundation

enum Shape: Int, CaseIterable {
    case diamond, squiggle, oval
}

enum Color: Int, CaseIterable {
    case red, green, blue
}

enum ShapeCount: Int, CaseIterable {
    case one, two, three
}

enum Shading: Int, CaseIterable {
    case solid, striped, open
}

struct Card: Identifiable {
    var id: String {
        "\(color) \(shape) \(count) \(shading)"
    }

    var color: Color
    var shape: Shape
    var count: ShapeCount
    var shading: Shading

    var isSelected: Bool
}

extension Card: CustomStringConvertible {
    var description: String {
        "\(color) \(shape) \(count) \(shading)"
    }
}

struct SetGameModel {
    var cards: [Card]

    init() {
        var cards = [Card]()
        for shape in Shape.allCases {
            for color in Color.allCases {
                for count in ShapeCount.allCases {
                    for shading in Shading.allCases {
                        cards.append(Card(color: color, shape: shape, count: count, shading: shading, isSelected: false))
                    }
                }
            }
        }
        self.cards = cards.shuffled()
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
