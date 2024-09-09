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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HexagonGrid()
                StatLinesAndCircles(stats: stats, maxValue: maxValue, geometry: geometry, onStatTap: onStatTap)
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

// 통계선과 원을 그리는 부분을 분리
struct StatLinesAndCircles: View {
    let stats: [Stat]
    let maxValue: Double
    let geometry: GeometryProxy
    var onStatTap: (String) -> Void
    
    var body: some View {
        ForEach(stats.indices, id: \.self) { index in
            let stat = stats[index]
            let angle = Angle(degrees: Double(index) * 60 - 90)
            let length = CGFloat(stat.value / maxValue) * min(geometry.size.width, geometry.size.height) / 2
            
            StatLine(angle: angle, length: length, geometry: geometry)
            StatCircle(stat: stat, angle: angle, length: length, geometry: geometry, onStatTap: onStatTap)
            StatLabel(stat: stat, angle: angle, geometry: geometry)
        }
    }
}

struct StatLine: View {
    let angle: Angle
    let length: CGFloat
    let geometry: GeometryProxy
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
            path.addLine(to: CGPoint(
                x: geometry.size.width / 2 + length * cos(angle.radians),
                y: geometry.size.height / 2 + length * sin(angle.radians)
            ))
        }
        .stroke(Color.blue, lineWidth: 2)
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
        // 계산식을 분리하여 컴파일러가 쉽게 처리하도록 만듦
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
