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
        VStack {
            ForEach(viewModel.model.cards) { card in
                Text("\(card.description)")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
