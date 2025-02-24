//
//  ProgressSummaryCard.swift
//  DailyFlow
//
//  Created by Rayyan Suhail on 2025-02-24.
//


import SwiftUI

// MARK: - RingView (Donut Chart for Progress)
struct RingView: View {
    let progress: Double        // 0.0 → 1.0
    let lineWidth: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    backgroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

// MARK: - Enhanced Progress Summary Card
struct ProgressSummaryCard: View {
    let tasks: [CardObject]
    
    private var total: Int {
        tasks.count
    }
    
    private var done: Int {
        tasks.filter { $0.isComplete }.count
    }
    
    private var pending: Int {
        total - done
    }
    
    private var completionRatio: Double {
        total == 0 ? 0.0 : Double(done) / Double(total)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppColors.colorOne,
                            AppColors.colorTwo,
                            AppColors.colorFour
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180) // a bit taller to fit extra stats

            VStack(alignment: .leading, spacing: 12) {
                Text("Today’s progress summary")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 5)

                HStack {
                    HStack(spacing: 22) {
                        // Donut chart
                        ZStack {
                            RingView(
                                progress: completionRatio,
                                lineWidth: 8,
                                foregroundColor: .white,
                                backgroundColor: .white.opacity(0.4)
                            )
                            .frame(width: 70, height: 70)
                            
                            // Show % in the center
                            Text("\(Int(completionRatio * 100))%")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        
                        // Stats breakdown
                        VStack(alignment: .leading, spacing: 4) {
                            ProgressStatRow(label: "Total", value: total)
                            ProgressStatRow(label: "Done", value: done)
                            ProgressStatRow(label: "Pending", value: pending)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Your action
                    }) {
                        Image("userImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .tint(.white)
                    }
                }
                .buttonStyle(WhiteOutlineCircleButtonStyle())
                .padding(.trailing, 30)


                Divider()
                    .background(Color.white.opacity(0.3))
                    .padding(.vertical, 4)

                Text("Tasks completed this week: 12") // Placeholder
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.9))
                    .offset(y: -3)
            }
            .padding(.leading, 25)
            .padding(.top, 16)
        }
    }
}

// MARK: - ProgressStatRow (Helper View for Stats)
struct ProgressStatRow: View {
    let label: String
    let value: Int

    var body: some View {
        HStack {
            Text("\(label): ")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
            Text("\(value)")
                .font(.footnote).bold()
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview
struct ProgressSummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgressSummaryCard(tasks: [
            CardObject(name: "UI Design", dueDate: "09:00 AM - 11:00 AM",
                       priority: "Medium", notes: "", isComplete: false),
            CardObject(name: "Web Development", dueDate: "11:30 AM - 12:30 PM",
                       priority: "High", notes: "Frontend improvements", isComplete: true),
            CardObject(name: "Office Meeting", dueDate: "02:00 PM - 03:00 PM",
                       priority: "Low", notes: "Discuss Q1 goals", isComplete: true)
        ])
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
