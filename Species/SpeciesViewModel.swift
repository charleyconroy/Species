//
//  SpeciesViewModel.swift
//  Species
//
//  Created by Charley Conroy on 4/18/23.
//

import Foundation

@MainActor
class SpeciesViewModel: ObservableObject {
    
    struct Returned: Codable {
        var next: String? //optional bc it's null on the next page
        var results: [Species]
    }
    
    @Published var speciesArray: [Species] = []
    @Published var isLoading = false
    
    var urlString = "https://swapi.dev/api/species/"
    
    func getData() async {
        isLoading = true
        print("🕸️Accessing url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("🤮ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data)
                urlString = returned.next ?? ""
                speciesArray += returned.results
                isLoading = false
            } catch {
                print("🤮JSON ERROR: Could not convert data into JSON \(error.localizedDescription)")
                isLoading = false
            }
        } catch {
            print("🤮 ERROR couldn't decode data from URL at \(urlString)")
            isLoading = false
        }
    }
    
    func loadNextIfNeeded(species: Species) async {
        guard let lastSpecies = speciesArray.last else {return}
        if lastSpecies.id == species.id && urlString != "" {
            await getData()
        }
    }
    
    func loadAll() async {
        guard urlString != "" else {return}
        await getData()
        await loadAll()
    }
}


// [Species.Species(id: nil, name: "Human", classification: "mammal", designation: "sentient", average_height: "180", average_lifespan: "120", language: "Galactic Basic", skin_colors: "caucasian, black, asian, hispanic", hair_colors: "blonde, brown, black, red", eye_colors: "brown, blue, green, hazel, grey, amber"), Species.Species(id: nil, name: "Droid", classification: "artificial", designation: "sentient", average_height: "n/a", average_lifespan: "indefinite", language: "n/a", skin_colors: "n/a", hair_colors: "n/a", eye_colors: "n/a"), Species.Species(id: nil, name: "Wookie", classification: "mammal", designation: "sentient", average_height: "210", average_lifespan: "400", language: "Shyriiwook", skin_colors: "gray", hair_colors: "black, brown", eye_colors: "blue, green, yellow, brown, golden, red"), Species.Species(id: nil, name: "Rodian", classification: "sentient", designation: "reptilian", average_height: "170", average_lifespan: "unknown", language: "Galatic Basic", skin_colors: "green, blue", hair_colors: "n/a", eye_colors: "black"), Species.Species(id: nil, name: "Hutt", classification: "gastropod", designation: "sentient", average_height: "300", average_lifespan: "1000", language: "Huttese", skin_colors: "green, brown, tan", hair_colors: "n/a", eye_colors: "yellow, red"), Species.Species(id: nil, name: "Yoda\'s species", classification: "mammal", designation: "sentient", average_height: "66", average_lifespan: "900", language: "Galactic basic", skin_colors: "green, yellow", hair_colors: "brown, white", eye_colors: "brown, green, yellow"), Species.Species(id: nil, name: "Trandoshan", classification: "reptile", designation: "sentient", average_height: "200", average_lifespan: "unknown", language: "Dosh", skin_colors: "brown, green", hair_colors: "none", eye_colors: "yellow, orange"), Species.Species(id: nil, name: "Mon Calamari", classification: "amphibian", designation: "sentient", average_height: "160", average_lifespan: "unknown", language: "Mon Calamarian", skin_colors: "red, blue, brown, magenta", hair_colors: "none", eye_colors: "yellow"), Species.Species(id: nil, name: "Ewok", classification: "mammal", designation: "sentient", average_height: "100", average_lifespan: "unknown", language: "Ewokese", skin_colors: "brown", hair_colors: "white, brown, black", eye_colors: "orange, brown"), Species.Species(id: nil, name: "Sullustan", classification: "mammal", designation: "sentient", average_height: "180", average_lifespan: "unknown", language: "Sullutese", skin_colors: "pale", hair_colors: "none", eye_colors: "black")]
