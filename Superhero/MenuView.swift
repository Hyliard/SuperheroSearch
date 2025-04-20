//
//  ContentView.swift
//  Superhero
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct MenuView: View {
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Estilo de fondo
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 0.13, green: 0.17, blue: 0.35),  // Azul oscuro
                    Color(red: 0.31, green: 0.20, blue: 0.46)   // Púrpura oscuro
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Elementos decorativos
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 300)
                    .offset(x: 100, y: -200)
                    .blur(radius: 10)
                
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 400)
                    .offset(x: -150, y: 300)
                    .blur(radius: 15)
                
                // Contenido principal
                VStack {
                    // Título
                    VStack(spacing: 8) {
                        Text("Superhero")
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                        
                        Text("Search")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.top, 80)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                    
                    Spacer()
                    
                    // Botones
                    VStack(spacing: 24) {
                        NavigationLink(destination: SuperheroSearcher()) {
                            ModernMenuButton(
                                icon: "magnifyingglass",
                                title: "Buscar Superhéroes",
                                color: .blue
                            )
                        }
                        
                        ModernMenuButton(
                            icon: "star.fill",
                            title: "Favoritos",
                            color: Color.yellow
                        )
                        .opacity(0.7)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
        .accentColor(.white)
    }
}

struct ModernMenuButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(color)
            
            Text(title)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    MenuView()
        .preferredColorScheme(.dark)
}
