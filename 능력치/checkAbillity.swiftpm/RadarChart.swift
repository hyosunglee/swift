//
//  RadarChart.swift
//  checkAbillity
//
//  Created by 공사떼 on 2024/09/10.
//
import SwiftUI

struct RadarChart: View {
    let stats: [Stat]
    let maxValue: Double
    var onStatTap: (String) -> Void
    
    @State private var animationProgress: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HexagonGrid()
                
                // StatLinesAndCircles의 애니메이션 부분 분리
                StatLinesAndCircles(stats: stats, maxValue: maxValue, geometry: geometry, onStatTap: onStatTap, animationProgress: $animationProgress)
            }
            .onAppear {
                // 뷰가 나타날 때 애니메이션 시작
                withAnimation(.easeInOut(duration: 1.0)) {
                    animationProgress = 1.0
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// Hexagon 그리기 부분을 분리
struct HexagonGrid: View {
    var body: some View {
        ZStack {
            HexagonShape()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            
            ForEach(0..<6) { i in
                HexagonShape()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .scaleEffect(CGFloat(5 - i) / 5)
            }
        }
    }
}

struct StatLinesAndCircles: View {
    let stats: [Stat]
    let maxValue: Double
    let geometry: GeometryProxy
    var onStatTap: (String) -> Void
    @Binding var animationProgress: CGFloat

    var body: some View {
        // 복잡한 로직을 작은 하위 뷰로 분리
        ForEach(stats.indices, id: \.self) { index in
            
            StatView(
                stat: stats[index],
                maxValue: maxValue,
                geometry: geometry,
                index: index,
                onStatTap: onStatTap,
                animationProgress: $animationProgress
            )
        }
    }
}

struct StatView: View {
    let stat: Stat
    let maxValue: Double
    let geometry: GeometryProxy
    let index: Int
    var onStatTap: (String) -> Void
    @Binding var animationProgress: CGFloat

    var body: some View {
        let angle = Angle(degrees: Double(index) * 60 - 90)
        let length = CGFloat(stat.value / maxValue) * min(geometry.size.width, geometry.size.height) / 2
        
        ZStack {
            StatLine(angle: angle, length: length, geometry: geometry, animationProgress: $animationProgress)
                

            StatCircle(stat: stat, angle: angle, length: length, geometry: geometry, onStatTap: onStatTap)
                .scaleEffect(animationProgress)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(Double(index) * 0.1), value: animationProgress)

            StatLabel(stat: stat, angle: angle, geometry: geometry)
        }
    }
}
// 통계선과 원을 그리는 부분을 분리하고, 애니메이션 효과를 부분적으로 적용


// 나머지 컴포넌트는 그대로 사용
struct StatLine: View {
    let angle: Angle
    let length: CGFloat
    let geometry: GeometryProxy
    
    @Binding var animationProgress: CGFloat
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
            path.addLine(to: CGPoint(
                x: geometry.size.width / 2 + length * cos(angle.radians),
                y: geometry.size.height / 2 + length * sin(angle.radians)
            ))
        }
        .trim(from: 0, to: animationProgress)  // trim 적용
                .stroke(Color.blue, lineWidth: 2)
                .animation(.easeInOut(duration: 1.0).delay(Double(angle.degrees / 60) * 0.1), value: animationProgress) // 애니메이션 적용
    }
}

struct StatCircle: View {
    let stat: Stat
    let angle: Angle
    let length: CGFloat
    let geometry: GeometryProxy
    var onStatTap: (String) -> Void
    
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 30, height: 30)
            .position(
                x: geometry.size.width / 2 + length * cos(angle.radians),
                y: geometry.size.height / 2 + length * sin(angle.radians)
            )
            .overlay(
                Text("\(Int(stat.value))")
                    .foregroundColor(.white)
                    .font(.caption)
            )
            .onTapGesture {
                onStatTap(stat.name)
            }
    }
}

struct StatLabel: View {
    let stat: Stat
    let angle: Angle
    let geometry: GeometryProxy
    
    var body: some View {
        let halfWidth = geometry.size.width / 2
        let halfHeight = geometry.size.height / 2
        let radius = min(geometry.size.width, geometry.size.height) / 2 + 20
        let xPosition = halfWidth + radius * cos(angle.radians)
        let yPosition = halfHeight + radius * sin(angle.radians)
        
        return Text(stat.name)
            .font(.caption)
            .position(x: xPosition, y: yPosition)
    }
}



