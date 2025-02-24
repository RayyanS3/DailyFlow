//
//  SwipableTaskRow.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//
import SwiftUI

// MARK: - SwipableTaskRow
struct SwipableTaskRow: View {
    let task: CardObject
    let icon: Image
    
    var onSwipeLeft: (CardObject) -> Void
    var onSwipeRight: (CardObject) -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)

            HStack {
                // Left icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .overlay(
                        icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.name)
                        .font(.subheadline)
                    Text(task.dueDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                if task.isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .frame(height: 80)
        // Horizontal offset for swiping
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset.width = gesture.translation.width
                }
                .onEnded { _ in
                    if offset.width > 100 {
                        onSwipeRight(task)
                    } else if offset.width < -100 {
                        onSwipeLeft(task)
                    }
                    withAnimation {
                        offset = .zero
                    }
                }
        )
    }
}
