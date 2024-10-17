import Foundation
import CoreLocation

class StoreService {
    static func loadStores() -> [Location] {
        let jsonString = """
        {
            "locations": [
              {
                  "id" : 1,
                "name_store" : "MediMate Manakau",
                "name": "1 Leyton Way, Manukau City Centre",
                "latitude": -36.991069,
                "longitude": 174.878280
              },
              {
                  "id" : 2,
                "name_store" : "MediMate NewMarket",
                "name": "277 Broadway, Newmarket",
                "latitude": -36.869167,
                "longitude": 174.777222
              },
              {
                  "id" : 3,
                "name_store" : "MediMate Mount Albert",
                "name": "80 Saint Lukes Road, Mount Albert",
                "latitude": -36.879907,
                "longitude": 174.737292
              },
              {
                  "id" : 4,
                "name_store" : "MediMate Albany",
                "name": "219 Don McKinnon Drive, Albany",
                "latitude": -36.730776,
                "longitude": 174.703392
              },
              {
                  "id" : 5,
                "name_store" : "MediMate CBD",
                "name": "34 Princes Street, Auckland CBD",
                "latitude": -36.848460,
                "longitude": 174.763332
              }
            ]
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8),
              let locationsData = try? JSONDecoder().decode(LocationsData.self, from: jsonData) else {
            return []
        }
        
        return locationsData.locations
    }
}
