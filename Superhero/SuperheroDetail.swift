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
    let id:String
    
    @State var superhero:ApiNetwork.SuperheroCompleted? = nil
    @State var loading:Bool = true
    var body: some View {
        VStack{
            if loading {
                ProgressView().tint(.white)
            }else if let superhero = superhero{
                WebImage(url: URL(string: superhero.image.url))
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                Text(superhero.name).bold().font(.title).foregroundColor(.white)
                ForEach(superhero.biography.aliases, id: \.self) { alias in
                    Text(alias).foregroundColor(.gray).italic()
                }
                SuperheroStats(stats: superhero.powerstats)
                
                Spacer()
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundApp"))
            .onAppear{
                Task{
                    do{
                        superhero = try await ApiNetwork().getHeroById(id: id)
                    }catch{
                        superhero = nil
                    }
                    loading = false
                }
            }
    }
}

struct SuperheroStats: View {
    let stats: ApiNetwork.Powerstats

    var data: [(String, Int)] {
        [
            ("Combat", Int(stats.combat) ?? 0),
            ("Durability", Int(stats.durability) ?? 0),
            ("Intelligence", Int(stats.intelligence) ?? 0),
            ("Power", Int(stats.power) ?? 0),
            ("Speed", Int(stats.speed) ?? 0),
            ("Strength", Int(stats.strength) ?? 0),
        ]
    }

    var body: some View {
        VStack(alignment: .center) {
            Text("Power Stats")
                .font(.headline)
                .padding(.bottom, 8)
            
            Chart(data, id: \.0) { stat in
                SectorMark(
                    angle: .value("Value", stat.1),
                    innerRadius: .ratio(0.5)
                )
                .foregroundStyle(by: .value("Stat", stat.0))
                .annotation(position: .overlay) {
                    Text(stat.0)
                        .font(.caption2)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 250, height: 250)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(24)
    }
}


#Preview {
    SuperheroDetail(id: "2")
}
