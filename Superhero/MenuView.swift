//
//  ContentView.swift
//  Superhero
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Estilo de fondo
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea() // cubre toda la pantalla
                
                VStack {
                    // Título de la App
                    Text("Superhero Search")
                        .font(.system(size: 40, weight: .heavy))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 100)
                        .opacity(0.9)
                        .transition(.move(edge: .top))
                        .animation(.easeOut(duration: 0.8), value: 1)
                    
                    Spacer()
                    
                    // Opcion
                    VStack(spacing: 20) {
                        
                        NavigationLink(destination: SuperheroSearcher()) {
                            HStack {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                Text("Buscar Superhéroes")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding(.horizontal)
                        }
                        .padding(.top, 30)
                        // a partir de aqui puedo colocar mas
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}



