import SwiftUI
import CoreLocation

struct StoreSelectionView: View {
    @Binding var selectedStore: Location?
    let stores: [Location]
    let userLocation: CLLocation?
    let onRecommendNearest: () -> Void
    
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: isOlderMode ? 16 : 12) {
            Text("Click & Collect Location")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 28 : 20)
                .foregroundColor(.primary)
            
            HStack {
                Text("Choose location")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .scalableFont(size: isOlderMode ? 24 : 16)
                
                Spacer()
                
                Picker("", selection: $selectedStore) {
                    Text("Select a store").tag(nil as Location?)
                    ForEach(stores) { store in
                        Text(store.name_store).tag(store as Location?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .scalableFont(size: isOlderMode ? 24 : 16)
                .accentColor(.blue)
            }
            
            if let store = selectedStore {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Selected: \(store.name_store)")
                        .scalableFont(size: isOlderMode ? 22 : 14)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Please select a pickup location")
                    .scalableFont(size: isOlderMode ? 22 : 14)
                    .foregroundColor(.red)
            }
            
            Button(action: onRecommendNearest) {
                Text("Recommend Nearest Store")
                    .scalableFont(size: isOlderMode ? 22 : 16)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding(isOlderMode ? 20 : 16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(isOlderMode ? 16 : 12)
        .frame(maxWidth: .infinity)
    }
}
