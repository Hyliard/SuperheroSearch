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
    @State private var showNoResults: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con gradiente para más profundidad
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("BackgroundApp"),
                        Color("BackgroundApp").opacity(0.8),
                        Color("BackgroundApp").opacity(0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Contenido principal
                VStack(spacing: 16) {
                    // Barra de búsqueda mejorada
                    searchField
                        .padding(.top, 8)
                    
                    // Estado de carga/error
                    if isLoading {
                        loadingView
                    } else if showError {
                        errorView
                    } else if showNoResults {
                        noResultsView
                    }
                    
                    // Lista de resultados con animación
                    if wrapper != nil && !(wrapper?.results.isEmpty ?? true) {
                        resultsList
                            .transition(.opacity.combined(with: .scale(0.95)))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .navigationTitle("Superhero Search")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Superhero Search")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // Componente de barra de búsqueda mejorado
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 18, weight: .semibold))
            
            TextField("", text: $superheroName, prompt: Text("Busca tu superhéroe...").foregroundColor(.white.opacity(0.7)))
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
                .submitLabel(.search)
                .onSubmit(performSearch)
                .font(.system(size: 16))
            
            if !superheroName.isEmpty {
                Button(action: {
                    superheroName = ""
                    wrapper = nil
                    showNoResults = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 18))
                }
                .transition(.opacity)
                .animation(.easeInOut, value: superheroName)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.15))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.3)]),
                    startPoint: .leading,
                    endPoint: .trailing
                ), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
    
    // Vista de carga mejorada
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.8)
                .padding(.bottom, 8)
            
            Text("Buscando superhéroes...")
                .foregroundColor(.white)
                .font(.headline)
            
            Text("Estamos consultando la base de datos de héroes")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal, 24)
        .transition(.opacity)
    }
    
    // Vista de error mejorada
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(.yellow)
                .symbolEffect(.pulse)
            
            Text("¡Ups! Algo salió mal")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            Text(errorMessage)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.horizontal, 20)
            
            Button(action: {
                withAnimation {
                    performSearch()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Reintentar")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
        .padding(.horizontal, 24)
        .transition(.opacity)
    }
    
    // Nueva vista para cuando no hay resultados
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.fill.questionmark")
                .font(.system(size: 44))
                .foregroundColor(.white.opacity(0.7))
            
            Text("No encontramos coincidencias")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            Text("Intenta con otro nombre o revisa la ortografía")
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .transition(.opacity)
    }
    
    // Lista de resultados mejorada
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(wrapper?.results ?? []) { superhero in
                    NavigationLink(destination: SuperheroDetail(id: superhero.id)) {
                        SuperheroItem(superhero: superhero)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
    }
    
    // Función para realizar la búsqueda con mejor manejo de estados
    private func performSearch() {
        guard !superheroName.isEmpty else {
            wrapper = nil
            showNoResults = false
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
            showError = false
            showNoResults = false
        }
        
        Task {
            do {
                let results = try await ApiNetwork().getHeroesByQuery(query: superheroName)
                
                withAnimation(.spring()) {
                    wrapper = results
                    isLoading = false
                    showNoResults = results.results.isEmpty
                }
            } catch {
                withAnimation {
                    isLoading = false
                    showError(message: error.localizedDescription)
                }
                print("Error: \(error.localizedDescription)")
            }
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
            // Imagen del superhéroe
            WebImage(url: URL(string: superhero.image.url))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(height: 220)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(16)
            
            // Nombre del superhéroe
            VStack(alignment: .leading, spacing: 8) {
                Text(superhero.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .frame(height: 220)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

// Componente para mostrar badges (etiquetas)
struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text.capitalized)
            .font(.caption.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.8))
            .cornerRadius(12)
    }
}

// Efecto personalizado para los botones
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    SuperheroSearcher()
        .preferredColorScheme(.dark)
}
