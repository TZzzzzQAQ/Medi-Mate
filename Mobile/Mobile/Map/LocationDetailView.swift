import SwiftUI
import MapKit

struct LocationDetailView: View {
    let location: Location
    @State private var position: MapCameraPosition
    @State private var satellite = false

    init(location: Location) {
        self.location = location
        self._position = State(initialValue: .region(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }
    
    var body: some View {
        Map(position: $position) {
            Annotation(location.name, coordinate: location.coordinate) {
                Image(systemName: "mappin.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
        }
        .mapStyle(satellite ? .imagery(elevation: .realistic) : .standard(elevation: .realistic))
        .overlay(alignment: .bottomTrailing) {
            Button {
                satellite.toggle()
            } label: {
                Image(systemName: satellite ? "globe.americas.fill" : "globe.americas")
                    .font(.title)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .padding()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button("View in 3D") {
                withAnimation {
                    position = .camera(MapCamera(
                        centerCoordinate: location.coordinate,
                        distance: 1000,
                        heading: 250,
                        pitch: 80
                    ))
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .padding()
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
