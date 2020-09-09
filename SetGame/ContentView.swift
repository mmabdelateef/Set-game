//
//  ContentView.swift
//  SetGame
//
//  Created by Mostafa Abdellateef on 28/08/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SetGameViewModel()

    @State private var didAppear = false
    var body: some View {
        GeometryReader { proxy in
            Grid(viewModel.cardsOnTable.compactMap {$0} ) { card in
                if didAppear, let card = card {
                    CardView(isCardSelected: card.isSelected, cardMatchState: self.matchState(for: card), cardShape: card.shape, cardShading: card.shading, shapeCount: card.count)
                        .padding(2)
                        .transition(.offset(randomPoint(outside: proxy.frame(in: .global))))
                        .animation(.easeIn(duration: 3))
                        .onTapGesture {
                            withAnimation(Animation.easeInOut(duration: 1)) {
                                viewModel.select(card: card)
                            }
                        }
                }
            }.onAppear {
                withAnimation(Animation.easeOut(duration: 4)) {
                    didAppear = true
                }
            }
        }
    }

    private func matchState(for card: Card) -> CardView.CardMatchState {
        if card.isMatch {
            return .match
        } else if card.isMissMatch {
            return .mismatch
        } else if card.isSelected {
            return .selected
        }
        return .unselected
    }
}

struct CardView: View {
    enum CardMatchState {
        case match
        case mismatch
        case selected
        case unselected
    }

    var isCardSelected: Bool
    var cardMatchState: CardMatchState
    var cardShape: CardShape
    var cardShading: Shading
    var shapeCount: ShapeCount

    var body: some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 5).foregroundColor(.white)
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(style: StrokeStyle(lineWidth: isCardSelected ? 5: 1))
                        .foregroundColor(self.color(for: self.cardMatchState))
                        .animation(nil)
                }
            }
            VStack {
                ForEach(1 ..< shapeCount.rawValue + 1) {  _ in
                    CardShapeView(cardShape: self.cardShape, isOpen: self.cardShading == .open)
                }.foregroundColor(self.color(for: cardMatchState))
            }.padding(16)
        }.padding(2)
    }

    func color(for cardMatchState: CardMatchState) -> SwiftUI.Color {
        switch cardMatchState {
        case .match:
            return .green
        case .mismatch:
            return .red
        case .selected:
            return .orange
        case .unselected:
            return .black
        }
    }
}

struct CardShapeView: Shape {
    var cardShape: CardShape
    var isOpen: Bool

    func path(in rect: CGRect) -> Path {
        switch cardShape {
        case .diamond:
            return Diamond(isOpen: isOpen).path(in: rect)
        case .squiggle:
            return Rectangle().path(in: rect)
        case .oval:
            return Circle().path(in: rect)
        }
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
    var isOpen: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()
        if isOpen { path = path.strokedPath(StrokeStyle(lineWidth: 4)) }
        return path
    }
}

func randomPoint(outside frame: CGRect) -> CGSize {
    // pick any random point in the frame
    let randomPointInFrame = CGPoint(x: CGFloat.random(in: frame.minX ... frame.maxX),
                                     y: CGFloat.random(in: frame.minY ... frame.maxY))
    let randomAmplitude = CGFloat(Int.random(in: 2...3) * [-1, 1].randomElement()!)
    return CGSize(width: randomAmplitude * randomPointInFrame.x, height: randomAmplitude * randomPointInFrame.y)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
