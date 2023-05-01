//
//  DetailView.swift
//  Species
//
//  Created by Charley Conroy on 4/18/23.
//

import SwiftUI

struct DetailView: View {
    let species: Species
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                Text(species.name)
                    .font(.largeTitle)
                .bold()
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundColor(.gray)
            }
            Group {
                HStack {
                    Text("Classification:")
                        .bold()
                    Text(species.classification)
                }
                HStack{
                    Text("Designation:")
                        .bold()
                    Text(species.designation)}
                HStack {
                    Text("Height:")
                        .bold()
                    Text(species.average_height)
                    Spacer()
                    Text("Lifespan:")
                        .bold()
                    Text(species.average_lifespan)
                    Spacer()
                }
                HStack{
                    Text("Language:")
                        .bold()
                    Text(species.classification)
                }
                HStack (alignment: .top) {
                    Text("Skin colors:")
                        .bold()
                    Text(species.skin_colors)
                        .multilineTextAlignment(.leading)
                }
                HStack(alignment: .top) {
                    Text("Hair colors:")
                        .bold()
                    Text(species.hair_colors)
                        .multilineTextAlignment(.leading)
                }
                HStack (alignment: .top){
                    Text("Eye colors:")
                        .bold()
                    Text(species.eye_colors)
                        .multilineTextAlignment(.leading)
                }
            }
            .font(.title2)
            VStack {
                AsyncImage(url: URL(string: returnSpeciesURL())) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 15)
                        .animation(.default, value: image)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    func returnSpeciesURL()-> String {
        var newName = species.name.replacingOccurrences(of: " ", with: "-")
        newName = newName.replacingOccurrences(of: "'", with: "")
        return "https://gallaugher.com/wp-content/uploads/2023/04/\(newName).jpg"
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(species: Species(name: "Swifter", classification: "Coder", designation: "sentient", average_height: "175", average_lifespan: "83", language: "Swift", skin_colors: "various", hair_colors: "various or none", eye_colors: "blue, green, brown, black, hazel, gray, violet"))
    }
}
