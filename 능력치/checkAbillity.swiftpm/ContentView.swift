import SwiftUI

struct Stat: Identifiable {
    let id = UUID()
    let name: String
    var value: Double
}

struct StatBar: View {
    let stat: Stat
    let maxValue: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(stat.name)
                Spacer()
                Text("\(Int(stat.value))/\(Int(maxValue))")
            }
            .font(.caption)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: geometry.size.width, height: 8)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: CGFloat(stat.value / maxValue) * geometry.size.width, height: 8)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            let angles = [0, 60, 120, 180, 240, 300].map { Angle(degrees: Double($0)) }
            
            path.move(to: CGPoint(x: center.x + radius * cos(angles[0].radians),
                                  y: center.y + radius * sin(angles[0].radians)))
            
            for angle in angles.dropFirst() {
                path.addLine(to: CGPoint(x: center.x + radius * cos(angle.radians),
                                         y: center.y + radius * sin(angle.radians)))
            }
            
            path.closeSubpath()
        }
    }
}





struct ContentView: View {
    @State private var stats = [
        Stat(name: "힘", value: 70),
        Stat(name: "지능", value: 85),
        Stat(name: "민첩", value: 60),
        Stat(name: "매력", value: 75),
        Stat(name: "지혜", value: 80),
        Stat(name: "체력", value: 65)
    ]
    
    @State private var selectedStat: String = "힘"
    @State private var showingMindMap = false
    
    let maxValue: Double = 100
    
    var body: some View {
        MindMapView(stat: selectedStat)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    RadarChart(stats: stats, maxValue: maxValue) { statName in
                        selectedStat = statName
                        showingMindMap = true
                    }
                    .frame(height: 300)
                    .padding()
                    
                    ForEach($stats) { $stat in
                        VStack {
                            StatBar(stat: stat, maxValue: maxValue)
                            Slider(value: $stat.value, in: 0...maxValue, step: 1)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("개인 능력치 대시보드")
            .sheet(isPresented: $showingMindMap) {
                if let stat = selectedStat {
                    MindMapView(stat: stat)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
