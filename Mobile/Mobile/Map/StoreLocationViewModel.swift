//
//  StoreLocationViewModel.swift
//  Mobile
//
//  Created by Lykheang Taing on 14/08/2024.
//


import Foundation
import CoreLocation

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []

    init() {
        loadLocations()
    }

    private func loadLocations() {
        guard let url = Bundle.main.url(forResource: "location", withExtension: "json") else {
            print("JSON file 'location.json' not found")
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                let locationsData = try JSONDecoder().decode(LocationsData.self, from: data)
                DispatchQueue.main.async {
                    self.locations = locationsData.locations
                    print("Loaded \(self.locations.count) locations")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }

    func location(at index: Int) -> Location? {
        guard locations.indices.contains(index) else { return nil }
        return locations[index]
    }
}
