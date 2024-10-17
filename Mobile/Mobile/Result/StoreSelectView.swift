import SwiftUI

struct StoreSelectionPopup: View {
    @Binding var isPresented: Bool
    @Binding var selectedStore: String?
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    @StateObject private var viewModel = StoreSelectVM()
    let productId: String
    let onLocationReceived: (ProductLocationData) -> Void
    
    let stores = ["Manakua", "NewMarket",  "Mount Albert", "Albany", "CBD"]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack {
                Text("Select a Store")
                    .scalableFont(size: isOlderMode ? 24 : 20, weight: .bold)
                    .padding()
                
                ForEach(stores.indices, id: \.self) { index in
                    Button(action: {
                        selectedStore = stores[index]
                        Task {
                            await viewModel.fetchProduct(productId: productId, pharmacyId: index + 1)
                        }
                    }) {
                        Text(stores[index])
                            .scalableFont(size: isOlderMode ? 20 : 16)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.primary)
                            .cornerRadius(isOlderMode ? 12 : 8)
                    }
                    .padding(.horizontal)
                }
                
                Button("Cancel") {
                    isPresented = false
                }
                .scalableFont(size: isOlderMode ? 18 : 14)
                .padding()
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(isOlderMode ? 20 : 15)
            .shadow(radius: 10)
            .padding(isOlderMode ? 30 : 20)
        }
        .onChange(of: viewModel.productLocation) { _, newValue in
            if let locationData = newValue {
                onLocationReceived(locationData)
                isPresented = false
            }
        }
    }
}
