//
//  SuperheroDetail.swift
//  Superhero
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Charts

struct SuperheroDetail: View {
    let id: String
    
    @State private var superhero: ApiNetwork.SuperheroCompleted?
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var selectedTab: InfoTab = .stats
    
    enum InfoTab: String, CaseIterable {
        case stats = "Estadísticas"
        case bio = "Biografía"
        case work = "Trabajo"
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundApp")
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(2)
                    .tint(.white)
            } else if let error = errorMessage {
                ErrorView(message: error)
            } else if let superhero = superhero {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Imagen grande como en la versión original
                        WebImage(url: URL(string: superhero.image.url))
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.2))
                            .shadow(radius: 10)
                        
                        // Contenido informativo
                        VStack(spacing: 20) {
                            // Nombre y alineación
                            VStack(spacing: 8) {
                                Text(superhero.name)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                if !superhero.biography.aliases.isEmpty {
                                    VStack(spacing: 4) {
                                        Text("También conocido como:")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        ForEach(superhero.biography.aliases, id: \.self) { alias in
                                            Text(alias)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                }
                                
                                if !superhero.biography.publisher.isEmpty {
                                    Text(superhero.biography.publisher)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                        .italic()
                                }
                                
                                // Badge de alineación debajo del nombre
                                if superhero.biography.alignment != "neutral" {
                                    Text(superhero.biography.alignment == "good" ? "Héroe" : "Villano")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(superhero.biography.alignment == "good" ? Color.green : Color.red)
                                        .cornerRadius(12)
                                        .padding(.top, 8)
                                }
                            }
                            
                            // Pestañas de información
                            HStack {
                                ForEach(InfoTab.allCases, id: \.self) { tab in
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            selectedTab = tab
                                        }
                                    }) {
                                        VStack {
                                            Text(tab.rawValue)
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundColor(selectedTab == tab ? .white : .gray)
                                            
                                            if selectedTab == tab {
                                                Capsule()
                                                    .fill(Color.blue)
                                                    .frame(height: 3)
                                            } else {
                                                Capsule()
                                                    .fill(Color.clear)
                                                    .frame(height: 3)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.top, 10)
                            
                            // Contenido según pestaña seleccionada
                            switch selectedTab {
                            case .stats:
                                VStack(spacing: 20) {
                                    // Gráfico radial mejorado
                                    RadarChart(stats: superhero.powerstats)
                                        .frame(height: 300)
                                        .padding(.vertical, 20)
                                    
                                    // Estadísticas detalladas
                                    VStack(spacing: 12) {
                                        StatRow(title: "Inteligencia", value: superhero.powerstats.intelligence, color: .purple)
                                        StatRow(title: "Fuerza", value: superhero.powerstats.strength, color: .red)
                                        StatRow(title: "Velocidad", value: superhero.powerstats.speed, color: .green)
                                        StatRow(title: "Durabilidad", value: superhero.powerstats.durability, color: .orange)
                                        StatRow(title: "Poder", value: superhero.powerstats.power, color: .blue)
                                        StatRow(title: "Combate", value: superhero.powerstats.combat, color: .yellow)
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.top, 20)
                                
                            case .bio:
                                VStack(alignment: .leading, spacing: 16) {
                                    if !superhero.biography.fullName.isEmpty {
                                        InfoCard(title: "Nombre completo", value: superhero.biography.fullName, icon: "person.fill")
                                    }
                                    
                                    if !superhero.biography.publisher.isEmpty {
                                        InfoCard(title: "Editorial", value: superhero.biography.publisher, icon: "building.2.fill")
                                    }
                                    
                                    if !superhero.biography.alignment.isEmpty {
                                        InfoCard(title: "Alineación",
                                                 value: superhero.biography.alignment == "good" ? "Héroe" : (superhero.biography.alignment == "bad" ? "Villano" : "Neutral"),
                                                 icon: superhero.biography.alignment == "good" ? "hand.thumbsup.fill" : (superhero.biography.alignment == "bad" ? "hand.thumbsdown.fill" : "minus.circle.fill"))
                                    }
                                    
                                    if !superhero.biography.aliases.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Image(systemName: "person.2.fill")
                                                    .foregroundColor(.blue)
                                                Text("Alias")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                ForEach(superhero.biography.aliases, id: \.self) { alias in
                                                    Text("• \(alias)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                            }
                                            .padding(.leading, 8)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(20)
                                
                            case .work:
                                VStack(alignment: .leading, spacing: 16) {
                                    if !superhero.work.occupation.isEmpty {
                                        InfoCard(title: "Ocupación", value: superhero.work.occupation, icon: "briefcase.fill")
                                    }
                                    
                                    if !superhero.work.base.isEmpty {
                                        InfoCard(title: "Base de operaciones", value: superhero.work.base, icon: "mappin.and.ellipse")
                                    }
                                }
                                .padding(20)
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .task {
            await loadHeroData()
        }
    }
    
    private func loadHeroData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            superhero = try await ApiNetwork().getHeroById(id: id)
        } catch {
            errorMessage = "No pudimos cargar los datos del héroe. Por favor intentalo nuevamente."
            print("Error loading hero: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

// Componente para mostrar filas de estadísticas
struct StatRow: View {
    let title: String
    let value: String
    let color: Color
    
    var intValue: Int {
        Int(value) ?? 0
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(width: 100, alignment: .leading)
            
            ProgressView(value: Double(intValue), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .scaleEffect(y: 1.5)
            
            Text("\(intValue)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 30)
        }
    }
}

// Componente para tarjetas de información
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// Gráfico radar personalizado
struct RadarChart: View {
    let stats: ApiNetwork.Powerstats
    
    private let maxValue: Double = 100
    private let categories = ["Int", "Str", "Spd", "Dur", "Pow", "Cbt"]
    
    private var data: [Double] {
        [
            Double(stats.intelligence) ?? 0,
            Double(stats.strength) ?? 0,
            Double(stats.speed) ?? 0,
            Double(stats.durability) ?? 0,
            Double(stats.power) ?? 0,
            Double(stats.combat) ?? 0
        ]
    }
    
    var body: some View {
        ZStack {
            // Fondo del radar
            RadarGrid(categories: categories, divisions: 5)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
            
            // Datos
            RadarShape(data: data, maxValue: maxValue)
                .fill(Color.blue.opacity(0.3))
                .overlay(
                    RadarShape(data: data, maxValue: maxValue)
                        .stroke(Color.blue, lineWidth: 2)
                )
            
            // Etiquetas
            ForEach(0..<categories.count, id: \.self) { index in
                let angle = Angle(degrees: Double(index) * 60 - 90).radians
                let category = categories[index]
                let value = String(format: "%.0f", data[index])
                
                VStack {
                    Text(category)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(value)
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
                .offset(x: cos(angle) * 80, y: sin(angle) * 80)
            }
        }
        .frame(width: 250, height: 250)
        .padding()
    }
}

// Forma del radar
struct RadarShape: Shape {
    let data: [Double]
    let maxValue: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        
        for (index, value) in data.enumerated() {
            let angle = Angle(degrees: Double(index) * 60 - 90).radians
            let normalizedValue = value / maxValue
            let point = CGPoint(
                x: center.x + cos(angle) * radius * normalizedValue,
                y: center.y + sin(angle) * radius * normalizedValue
            )
            
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// Rejilla del radar
struct RadarGrid: Shape {
    let categories: [String]
    let divisions: Int
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        
        // Líneas radiales
        for (index, _) in categories.enumerated() {
            let angle = Angle(degrees: Double(index) * 60 - 90).radians
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
            
            path.move(to: center)
            path.addLine(to: point)
        }
        
        // Círculos concéntricos
        for division in 1...divisions {
            let divisionRadius = radius * CGFloat(division) / CGFloat(divisions)
            path.addEllipse(in: CGRect(
                x: center.x - divisionRadius,
                y: center.y - divisionRadius,
                width: divisionRadius * 2,
                height: divisionRadius * 2
            ))
        }
        
        return path
    }
}

// Vista de error
struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Reintentar") {
                // Aquí podrías agregar lógica para reintentar
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
    }
}

#Preview {
    SuperheroDetail(id: "2")
        .preferredColorScheme(.dark)
}
