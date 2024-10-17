import SwiftUI

struct ResultsView: View {
    @ObservedObject var HomeVM: HomeVM
    @StateObject private var comparisonViewModel = ComparisonViewModel()
    @State private var selectedProducts: Set<String> = []
    @State private var navigateToComparison = false
    @State private var selectedProductId: String?
    @State private var isCompareMode = false
    @State private var navigateToProductDetails: String?
    
    // State variables for location feature
    @State private var isStoreSelectionPresented = false
    @State private var selectedStore: String?
    @State private var locationData: ProductLocationData?
    @State private var isShowingLocationView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if HomeVM.products.isEmpty {
                                emptyResultsView
                            } else {
                                ForEach(HomeVM.products) { product in
                                    productView(for: product)
                                        .id(product.id)
                                        .onAppear {
                                            HomeVM.lastViewedItemId = product.id
                                            HomeVM.loadMoreProductsIfNeeded(currentProduct: product)
                                        }
                                }
                                if HomeVM.isLoading {
                                    ProgressView()
                                        .frame(height: 50)
                                }
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        if let id = HomeVM.lastViewedItemId {
                            proxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
                
                if isCompareMode {
                    compareButtons
                        .padding(.bottom, 50)
                }
                
                Color(.secondarySystemBackground)
                    .frame(height: 49)
                    .opacity(0.01)
            }
            .navigationTitle(isCompareMode ? "Select Products" : "Results")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { productId in
                ProductDetailsView(productId: productId)
            }
            .navigationDestination(isPresented: $navigateToComparison) {
                ComparisonView(viewModel: comparisonViewModel, productIds: Array(selectedProducts))
            }
//            .toolbar {
//                if isCompareMode {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Done") {
//                            exitCompareMode()
//                        }
//                    }
//                }
//            }
            .sheet(isPresented: $isShowingLocationView) {
                if let data = locationData {
                    NavigationStack {
                        LocationView(location: StoreLocation(rawValue: data.shelfNumber) ?? .a, productLocation: data)
                            .navigationBarItems(leading: Button("Back") {
                                isShowingLocationView = false
                            })
                    }
                }
            }
            .overlay(
                Group {
                    if isStoreSelectionPresented {
                        StoreSelectionPopup(
                            isPresented: $isStoreSelectionPresented,
                            selectedStore: $selectedStore,
                            productId: selectedProductId ?? ""
                        ) { data in
                            locationData = data
                            isShowingLocationView = true
                        }
                    }
                }
            )
        }
    }
    
    private var emptyResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No results found")
                .font(.title2)
                .fontWeight(.bold)
            Text("Try adjusting your search or take a clearer picture.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func productView(for product: Medicine) -> some View {
        ProductCard(product: product, isSelected: selectedProducts.contains(product.id), onLocationTap: {
            isStoreSelectionPresented = true
            selectedProductId = product.id
        })
        .background(
            NavigationLink(destination: ProductDetailsView(productId: product.id), tag: product.id, selection: $navigateToProductDetails) {
                EmptyView()
            }
        )
        .onTapGesture {
            if isCompareMode {
                toggleSelection(for: product.id)
            } else {
                navigateToProductDetails = product.id
            }
        }
        .onLongPressGesture {
            if !isCompareMode {
                enterCompareMode(selecting: product.id)
            }
        }
    }
    
    private var compareButtons: some View {
        HStack(spacing: 16) {
            Button(action: {
                if selectedProducts.count >= 2 {
                    comparisonViewModel.fetchComparisons(productIds: Array(selectedProducts))
                    navigateToComparison = true
                }
            }) {
                Text("Compare (\(selectedProducts.count))")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(selectedProducts.count >= 2 ? Color.blue : Color.gray)
                    .cornerRadius(25)
            }
            .disabled(selectedProducts.count < 2)
            
            Button(action: {
                exitCompareMode()
            }) {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.red)
                    .cornerRadius(25)
            }
        }
        .padding(.horizontal)
        .frame(height: 55)
    }
    
    private func enterCompareMode(selecting id: String) {
        isCompareMode = true
        selectedProducts = [id]
    }
    
    private func exitCompareMode() {
        isCompareMode = false
        selectedProducts.removeAll()
    }
    
    private func toggleSelection(for id: String) {
        if selectedProducts.contains(id) {
            selectedProducts.remove(id)
        } else if selectedProducts.count < 5 {
            selectedProducts.insert(id)
        }
    }
}

struct ProductCard: View {
    let product: Medicine
    var isSelected: Bool
    var onLocationTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                HStack(alignment: .top, spacing: 12) {
                    productImage
                    productInfo
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer(minLength: 0)
                }
                .padding()
                
                Button(action: onLocationTap) {
                    Image(systemName: "mappin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .position(x: geometry.size.width - 25, y: geometry.size.height - 20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .frame(height: 100)
    }
    
    private var productImage: some View {
        AsyncImage(url: URL(string: product.imageSrc)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 80, height: 80)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                    .frame(width: 80, height: 80)
            @unknown default:
                EmptyView()
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.productName)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.primary)
            Text("Price: \(product.productPrice)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let manufacturer = product.manufacturerName {
                Text(manufacturer)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
