import SwiftUI
import MapKit

struct StoreLocationsView: View {
    @StateObject private var viewModel = LocationViewModel()
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.locations) { location in
                        locationPreview(location: location, geometry: geo)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("MediMate Locations")
        .scalableFont(size: 20, weight: .bold) // For the navigation title
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    @ViewBuilder
    private func locationPreview(location: Location, geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(location.name_store)
                .scalableFont(size: 18, weight: .semibold)
                .foregroundColor(.primary)
            
            Text(location.name)
                .scalableFont(size: 14)
                .foregroundColor(.secondary)
            
            NavigationLink(destination: LocationDetailView(location: location)) {
                MapView(location: location)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
            
            Button(action: {
                let url = URL(string: "maps://?q=\(location.coordinate.latitude),\(location.coordinate.longitude)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }) {
                HStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(.blue)
                    Text("Open in Maps")
                        .scalableFont(size: 12)
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: geometry.size.width - 32)
    }
}
