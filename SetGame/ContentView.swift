//
//  ContentView.swift
//  SetGame
//
//  Created by Mostafa Abdellateef on 28/08/2020.
//

import SwiftUI

struct ContentView: View {
    let viewModel = SetGameViewModel()
    var body: some View {
        Grid(viewModel.model.cards) { card in
            CardView(card: card)
                .padding(2)
        }

    }
}

struct CardView: View {

    var card: Card
    var body: some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 5))
            }.foregroundColor(.green)
            VStack {
                ForEach(1 ..< card.count.rawValue + 1) {  _ in
                    switch card.shape {
                    case .squiggle:
                        Rectangle()
                    case .oval:
                        Circle()
                    case .diamond:
                        Diamond()
                    }
                }.foregroundColor(card.cardColor)
            }.padding(16)
        }.padding(2)
    }

}

extension Card {
    var cardColor: SwiftUI.Color {
        switch self.color {
        case .purple:
            return .purple
        case .blue:
            return .blue
        case .red:
            return .red
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
