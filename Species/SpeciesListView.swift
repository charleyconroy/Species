//
//  ContentView.swift
//  Species
//
//  Created by Charley Conroy on 4/18/23.
//

import SwiftUI
import AVFAudio

struct SpeciesListView: View {
    @StateObject var speciesVM = SpeciesViewModel()
    @State private var audioPlayer: AVAudioPlayer!
    @State private var lastSound = -1
    var body: some View {
        NavigationStack {
            ZStack {
                List(speciesVM.speciesArray) { species in
                    LazyVStack {
                        NavigationLink {
                            DetailView(species: species)
                        } label: {
                            Text(species.name)
                        }
                    }
                    .task {
                        await speciesVM.loadNextIfNeeded(species: species)
                    }
                }
                .font(.title)
                .listStyle(.plain)
                .navigationTitle("Species")
                if speciesVM.isLoading {
                    ProgressView()
                        .scaleEffect(4)
                        .tint(.green)
                }
            }
            .toolbar {
                ToolbarItem(placement: .status) {
                    Text("\(speciesVM.speciesArray.count) Species Returned")
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Load All") {
                        Task {
                            await speciesVM.loadAll()
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        var nextSound: Int
                        repeat {
                            nextSound = Int.random(in: 0...8)
                        } while nextSound == lastSound
                        lastSound = nextSound
                        playSound(soundName: "\(lastSound)")
                    } label: {
                        Image("peek")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                    }
                }
            }
        }
        .task {
            await speciesVM.getData()
        }
    }
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("could not read file")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription) creating audioplayer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesListView()
    }
}
