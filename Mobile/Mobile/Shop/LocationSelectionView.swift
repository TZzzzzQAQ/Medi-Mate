import SwiftUI
import CoreLocation

struct LocationSelectionView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var authViewModel: AuthenticationView
    @StateObject private var locationManager = LocationManager()
    @State private var stores: [Location] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingPermissionGuide = false
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isCareMode") private var isOlderMode = false
    @Namespace private var animation

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    storeSelectionSection
                    
                    recommendNearestStoreButton
                    
                    selectedStoreInfo
                    
                    Spacer()
                    
                    proceedToCheckoutButton
                }
                .padding()
            }
            .navigationTitle("Select Pickup Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                stores = StoreService.loadStores()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingPermissionGuide) {
            LocationPermissionGuideView(locationManager: locationManager)
        }
    }

    private var storeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Click & Collect Location")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 24 : 20)
                .foregroundColor(.primary)
            
            Menu {
                ForEach(stores) { store in
                    Button(action: {
                        withAnimation(.spring()) {
                            cartManager.selectedStore = store
                        }
                    }) {
                        Text(store.name_store)
                    }
                }
            } label: {
                HStack {
                    Text(cartManager.selectedStore?.name_store ?? "Select a store")
                        .scalableFont(size: isOlderMode ? 22 : 18)
                        .foregroundColor(cartManager.selectedStore == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var recommendNearestStoreButton: some View {
        Button(action: recommendNearestStore) {
            HStack {
                Image(systemName: "location.fill")
                Text("Recommend Nearest Store")
            }
            .scalableFont(size: isOlderMode ? 22 : 18)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(16)
        }
        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
    }

    private var selectedStoreInfo: some View {
        Group {
            if let store = cartManager.selectedStore {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Store:")
                        .font(.headline)
                        .scalableFont(size: isOlderMode ? 22 : 18)
                    Text(store.name_store)
                        .scalableFont(size: isOlderMode ? 20 : 16)
                    Text(store.name)
                        .scalableFont(size: isOlderMode ? 18 : 14)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(16)
                .transition(.opacity.combined(with: .scale))
            }
        }
    }

    private var proceedToCheckoutButton: some View {
        Button(action: proceedToCheckout) {
            Text("Proceed to Checkout")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 26 : 22)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, isOlderMode ? 20 : 16)
                .background(cartManager.selectedStore == nil ? Color.gray.opacity(0.7) : Color.green)
                .cornerRadius(20)
        }
        .disabled(cartManager.selectedStore == nil)
        .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
    }

    private func recommendNearestStore() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if let userLocation = locationManager.location {
                findNearestStore(from: userLocation)
            } else {
                showingAlert = true
                alertMessage = "Unable to determine your location. Please try again."
            }
        case .denied, .restricted:
            showingAlert = true
            alertMessage = "Location access is denied. Please enable it in Settings to use this feature."
        case .notDetermined:
            showingPermissionGuide = true
        @unknown default:
            showingAlert = true
            alertMessage = "Unknown location authorization status. Please try again."
        }
    }

    private func findNearestStore(from userLocation: CLLocation) {
        let nearestStore = stores.min { store1, store2 in
            userLocation.distance(from: CLLocation(latitude: store1.latitude, longitude: store1.longitude)) <
            userLocation.distance(from: CLLocation(latitude: store2.latitude, longitude: store2.longitude))
        }
        
        if let store = nearestStore {
            cartManager.selectedStore = store
            showingAlert = true
            alertMessage = "Nearest store: \(store.name_store)"
        } else {
            showingAlert = true
            alertMessage = "Unable to find the nearest store. Please try again."
        }
    }

    private func proceedToCheckout() {
        guard let store = cartManager.selectedStore else {
            showingAlert = true
            alertMessage = "Please select a store"
            return
        }
        
        guard !authViewModel.userId.isEmpty else {
            showingAlert = true
            alertMessage = "User ID not available. Please log in again."
            return
        }
        
        guard let order = cartManager.prepareOrder(userId: authViewModel.userId) else {
            showingAlert = true
            alertMessage = "Failed to prepare order"
            return
        }
        
        submitOrder(order, cartManager: cartManager) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("Order submitted successfully: \(message)")
                    self.cartManager.clearCart()
                    showingAlert = true
                    alertMessage = "Order submitted successfully!"
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print("Failed to submit order: \(error.localizedDescription)")
                    showingAlert = true
                    alertMessage = "Failed to submit order: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct LocationPermissionGuideView: View {
    @ObservedObject var locationManager: LocationManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Location Permission Required")
                .font(.title)
                .fontWeight(.bold)

            Image(systemName: "location.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)

            Text("To recommend the nearest store, we need access to your location.")
                .multilineTextAlignment(.center)
                .padding()

            Text("1. Tap 'Allow Location Access' below")
            Text("2. Choose 'Allow While Using App'")
            Text("3. You're all set!")

            Button(action: {
                locationManager.requestLocationPermission()
            }) {
                Text("Allow Location Access")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Button("Maybe Later") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.secondary)
        }
        .padding()
    }
}
