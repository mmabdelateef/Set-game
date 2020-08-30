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
                    CardView(card: card)
                        .padding(2)
                        .transition(.offset(randomPoint(outside: proxy.frame(in: .global))))
                        .onTapGesture {
                            withAnimation(Animation.easeIn(duration: 3)) {
                                viewModel.select(card: card)
                            }
                        }
                }
            }.onAppear {
                withAnimation(Animation.easeOut) {
                    didAppear = true
                }
            }
        }
    }
}

struct CardView: View {

    var card: Card
    var body: some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 5).foregroundColor(.white)
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: card.isSelected ? 5: 1))
            }.foregroundColor(color(for: card))
            VStack {
                ForEach(1 ..< card.count.rawValue + 1) {  _ in
                    shape(for: card)
                }.foregroundColor(card.cardColor)
            }.padding(16)
        }.padding(2)
    }

    func shape(for card: Card) -> some View {
        Group {
            switch card.shape {
            case .squiggle:
                Rectangle()
            case .oval:
                Circle()
            case .diamond:
                Diamond()
            }
        }.opacity(card.shading == .striped ? 0.3 : 1)
    }

    func color(for card: Card) -> SwiftUI.Color {
        guard card.isSelected else { return .black }

        if card.isMatch {
            return .green
        } else if card.isMissMatch {
            return .red
        } else {
            return .orange
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
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
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
