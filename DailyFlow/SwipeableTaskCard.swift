//
//  SwipeableTaskCard.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-26.
//


import SwiftUI

struct SwipeableTaskCard: View {
    let task: CardObject
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    
    @State private var offset: CGFloat = 0
    @GestureState private var dragState: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
                .overlay(
                    VStack {
                        Text(task.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(task.notes)
                            .font(.body)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                )
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .updating($dragState) { drag, state, _ in
                            state = drag.translation
                        }
                        .onChanged { gesture in
                            offset = gesture.translation.width
                        }
                        .onEnded { _ in
                            if offset > 100 {
                                onSwipeRight()
                            } else if offset < -100 {
                                onSwipeLeft()
                            }
                            offset = 0
                        }
                )
        }
        .frame(width: 300, height: 400)
    }
}
