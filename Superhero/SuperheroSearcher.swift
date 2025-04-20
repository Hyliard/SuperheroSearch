//
//  SuperheroSearcher.swift
//  Superhero
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct SuperheroSearcher: View {
    @State private var superheroName: String = ""
    @State private var wrapper: ApiNetwork.Wrapper? = nil
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con capa de overlay para mejor contraste
                Color("BackgroundApp")
                    .ignoresSafeArea()
                
                // Contenido principal
                VStack(spacing: 20) {
                    // Barra de búsqueda moderna
                    searchField
                    
                    // Estado de carga/error
                    if isLoading {
                        loadingView
                    } else if showError {
                        errorView
                    }
                    
                    // Lista de resultados
                    resultsList
                }
                .padding(.horizontal)
                .navigationTitle("Superhero Search")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // Componente de barra de búsqueda
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.7))
            
            TextField("", text: $superheroName, prompt: Text("Busca tu superhéroe...").foregroundColor(.white.opacity(0.7)))
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
                .submitLabel(.search)
                .onSubmit(performSearch)
            
            if !superheroName.isEmpty {
                Button(action: {
                    superheroName = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.5), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Vista de carga
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            Text("Buscando superhéroes...")
                .foregroundColor(.white)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
    // Vista de error
    private var errorView: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            
            Text(errorMessage)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Button("Reintentar") {
                performSearch()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // Lista de resultados
    private var resultsList: some View {
        List {
            ForEach(wrapper?.results ?? []) { superhero in
                SuperheroItem(superhero: superhero)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .overlay(
                        NavigationLink(destination: SuperheroDetail(id: superhero.id)) {
                            EmptyView()
                        }
                        .opacity(0)
                    )
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // Función para realizar la búsqueda
    private func performSearch() {
        guard !superheroName.isEmpty else { return }
        
        isLoading = true
        showError = false
        
        Task {
            do {
                wrapper = try await ApiNetwork().getHeroesByQuery(query: superheroName)
                if wrapper?.results.isEmpty ?? true {
                    showError(message: "No encontramos superhéroes con ese nombre")
                }
            } catch {
                showError(message: "Error al buscar superhéroes. Intenta nuevamente.")
                print("Error: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}

struct SuperheroItem: View {
    let superhero: ApiNetwork.Superhero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Imagen del superhéroe con efecto de overlay
            WebImage(url: URL(string: superhero.image.url))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(height: 220)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(16)
            
            // Nombre del superhéroe
            VStack(alignment: .leading, spacing: 4) {
                Text(superhero.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Nota: Aquí originalmente intentabas mostrar publisher,
                // pero no está disponible en Superhero básico
                // Para mostrarlo necesitarías usar SuperheroCompleted
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .frame(height: 220)
        .padding(.horizontal, 8)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    SuperheroSearcher()
        .preferredColorScheme(.dark)
}
