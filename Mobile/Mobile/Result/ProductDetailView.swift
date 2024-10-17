import SwiftUI
import AVFoundation

struct ProductDetailsView: View {
    @StateObject private var viewModel: ProductDetailsVM
    @State private var selectedSection: String?
    @State private var isStoreSelectionPresented = false
    @State private var selectedStore: String?
    @State private var locationData: ProductLocationData?
    @State private var isShowingLocationView = false
    @State private var isShowingLoginView = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var authViewModel: AuthenticationView
    
    init(productId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailsVM(productId: productId, cartManager: CartManager()))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                ScrollView {
                    VStack(spacing: 20) {
                        switch viewModel.state {
                        case .idle, .loading:
                            ProgressView("Loading...")
                                .scalableFont(size: 18)
                        case .loaded(let details):
                            ProductDetailsContent(
                                details: details,
                                viewModel: viewModel,
                                selectedSection: $selectedSection,
                                isStoreSelectionPresented: $isStoreSelectionPresented,
                                selectedStore: $selectedStore,
                                locationData: $locationData,
                                isShowingLocationView: $isShowingLocationView,
                                isShowingLoginView: $isShowingLoginView,
                                isLoggedIn: authViewModel.isLoginSuccessed
                            )
                        case .error(let error):
                            ErrorView(error: error, retryAction: { Task { await viewModel.loadProductDetails() } })
                        }
                    }
                    .padding()
                }
                
                if isStoreSelectionPresented {
                    StoreSelectionPopup(
                        isPresented: $isStoreSelectionPresented,
                        selectedStore: $selectedStore,
                        productId: viewModel.productId
                    ) { data in
                        locationData = data
                        isShowingLocationView = true
                    }
                }
            }
            .navigationTitle("Product Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    speakButton
                }
            }
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
            .sheet(isPresented: Binding(
                get: { isShowingLoginView && !authViewModel.isLoginSuccessed },
                set: { isShowingLoginView = $0 }
            )) {
                LoginView(authViewModel: authViewModel)
            }
        }
        .onAppear {
            viewModel.updateCartManager(cartManager)
        }
        .task {
            await viewModel.loadProductDetails()
        }
        .onChange(of: authViewModel.isLoginSuccessed) {oldValue, newValue in
            if newValue {
                isShowingLoginView = false
                viewModel.updateCart()
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(colorScheme == .dark ? .systemGray6 : .systemBackground),
                Color(colorScheme == .dark ? .systemGray5 : .systemGray6)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private var speakButton: some View {
        Button(action: {
            viewModel.toggleSpeaking()
        }) {
            Image(systemName: viewModel.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                .foregroundColor(viewModel.isSpeaking ? .red : .blue)
                .font(.system(size: 22))
        }
    }
}

struct ProductDetailsContent: View {
    let details: ProductDetails
    @ObservedObject var viewModel: ProductDetailsVM
    @Binding var selectedSection: String?
    @Binding var isStoreSelectionPresented: Bool
    @Binding var selectedStore: String?
    @Binding var locationData: ProductLocationData?
    @Binding var isShowingLocationView: Bool
    @Binding var isShowingLoginView: Bool
    let isLoggedIn: Bool
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            productImage
            productInfo
            priceAndQuantitySection
            addToCartButton
            
            summarySection
            
            contentSections
        }
        .background(Color(UIColor.systemBackground).opacity(0.8))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .onAppear {
            viewModel.updateQuantityFromCart()
        }
    }
    
    private var storeSection: some View {
        HStack {
            Image(systemName: "house.fill")
                .foregroundColor(.blue)
            Text(selectedStore ?? "In Store Location")
                .scalableFont(size: isOlderMode ? 20 : 16)
            Spacer()
            Button("Choose Store") {
                isStoreSelectionPresented = true
            }
            .foregroundColor(.blue)
            .scalableFont(size: isOlderMode ? 18 : 14)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    private var productImage: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: details.imageSrc)) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.width)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.width)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.system(size: geometry.size.width * 0.3))
                            .frame(width: geometry.size.width, height: geometry.size.width)
                            .background(Color(UIColor.systemGray6))
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .transition(.opacity) // Add a transition
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(.horizontal, isOlderMode ? 20 : 16)
        .animation(.easeInOut, value: details.imageSrc) // Animate based on image URL changes
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
//            Text("I/N: \(details.productId)")
//                .scalableFont(size: isOlderMode ? 16 : 12)
//                .foregroundColor(.secondary)
            Text(details.productName)
                .scalableFont(size: isOlderMode ? 28 : 22, weight: .bold)
                .foregroundColor(.primary)
        }
    }
    
    private var priceAndQuantitySection: some View {
            HStack(alignment: .center, spacing: 20) {
                // Price
                VStack(alignment: .leading, spacing: 4) {
                    Text("NZD")
                        .scalableFont(size: isOlderMode ? 16 : 14, weight: .medium)
                        .foregroundColor(.secondary)
                    Text(details.productPrice)
                        .scalableFont(size: isOlderMode ? 32 : 26, weight: .bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Quantity
                Stepper {
                    Text("Quantity: \(viewModel.quantity)")
                        .scalableFont(size: isOlderMode ? 20 : 16)
                } onIncrement: {
                    viewModel.updateQuantity(viewModel.quantity + 1)
                } onDecrement: {
                    viewModel.updateQuantity(viewModel.quantity - 1)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, isOlderMode ? 16 : 12)
            .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
            .cornerRadius(12)
        }

        private var addToCartButton: some View {
            Button(action: {
                if isLoggedIn {
                    viewModel.updateCart()
                } else {
                    isShowingLoginView = true
                }
            }) {
                HStack {
                    Text(viewModel.isAddedToCart ? "Update Cart" : "Add to Cart")
                    if viewModel.isAddedToCart {
                        Text("(\(viewModel.quantity))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isAddedToCart ? Color.blue : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .scalableFont(size: isOlderMode ? 22 : 18, weight: .semibold)
            }
            .animation(.easeInOut, value: viewModel.isAddedToCart)
            .animation(.easeInOut, value: viewModel.quantity)
        }

        private var quantitySelector: some View {
            HStack(spacing: 12) {
                Button(action: { viewModel.updateQuantity(viewModel.quantity - 1) }) {
                    Image(systemName: "minus")
                        .padding(8)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(8)
                }
                
                Text("\(viewModel.quantity)")
                    .font(.custom("Avenir-Black", size: isOlderMode ? 24 : 20))
                    .frame(width: 40)
                
                Button(action: { viewModel.updateQuantity(viewModel.quantity + 1) }) {
                    Image(systemName: "plus")
                        .padding(8)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(8)
                }
            }
            .foregroundColor(.primary)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
        }
    

    
    
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: isOlderMode ? 15 : 10) {
            Text("AI Generated Summary")
                .scalableFont(size: isOlderMode ? 26 : 20, weight: .bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text(details.summary)
                .scalableFont(size: isOlderMode ? 20 : 16)
                .padding()
                .background(
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4), Color.red.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        RoundedRectangle(cornerRadius: isOlderMode ? 15 : 10)
                            .stroke(Color.white.opacity(0.2), lineWidth: isOlderMode ? 3 : 2)
                    }
                )
                .foregroundColor(.white)
                .cornerRadius(isOlderMode ? 15 : 10)
                .shadow(color: Color.black.opacity(0.1), radius: isOlderMode ? 8 : 5, x: 0, y: 5)
            
            HStack {
                Text("Powered by AI")
                    .scalableFont(size: isOlderMode ? 16 : 12)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Link("Disclaimer", destination: URL(string: "https://bevel-terrier-8ea.notion.site/Disclaimer-for-Medimat-07344876198445109e7f671666fb3a54")!)
                    .scalableFont(size: isOlderMode ? 16 : 12)
                    .foregroundColor(.blue)
            }
            .padding(.top, isOlderMode ? 10 : 5)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(isOlderMode ? 20 : 15)
    }
    
    private var readAloudSection: some View {
        VStack(spacing: isOlderMode ? 15 : 10) {
            Button(action: {
                viewModel.toggleSpeaking()
            }) {
                HStack {
                    Image(systemName: viewModel.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: isOlderMode ? 30 : 24))
                    Text(viewModel.isSpeaking ? "Stop Reading" : "Read Aloud")
                        .scalableFont(size: isOlderMode ? 24 : 20, weight: .semibold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isSpeaking ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(isOlderMode ? 15 : 10)
            }
            
            if viewModel.isSpeaking {
                HStack {
                    Text("Speed:")
                        .scalableFont(size: isOlderMode ? 20 : 16)
                    ForEach(["Normal", "Fast", "Very Fast"], id: \.self) { speed in
                        Button(speed) {
                            viewModel.updateSpeechRate(forSpeed: speed)
                        }
                        .buttonStyle(.bordered)
                        .tint(viewModel.currentSpeedLabel == speed ? .green : .blue)
                        .scalableFont(size: isOlderMode ? 18 : 14)
                    }
                }
            }
        }
    }
    private var contentSections: some View {
            VStack(alignment: .leading, spacing: isOlderMode ? 25 : 20) {
                ForEach([
                    ("General Information", details.generalInformation ?? "Not Available"),
                    ("Warnings", details.warnings ?? "Not Available"),
                    ("Common Use", details.commonUse ?? "Not Available"),
                    ("Ingredients", details.ingredients ?? "Not Available"),
                    ("Directions", details.directions ?? "Not Available")
                ], id: \.0) { title, content in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { selectedSection == title },
                            set: { if $0 { selectedSection = title } else { selectedSection = nil } }
                        )
                    ) {
                        Text(content)
                            .scalableFont(size: isOlderMode ? 18 : 16)
                            .padding(.vertical)
                    } label: {
                        HStack {
                            Text(title)
                                .scalableFont(size: isOlderMode ? 22 : 18, weight: .semibold)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: selectedSection == title ? "chevron.up" : "chevron.down")
                                .foregroundColor(.secondary)
                                .animation(.easeInOut, value: selectedSection)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(isOlderMode ? 15 : 10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .animation(.easeInOut, value: selectedSection)
                }
            }
        }
    }

    struct ErrorView: View {
        let error: Error
        let retryAction: () -> Void
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
        @AppStorage("isCareMode") private var isOlderMode = false
        
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: isOlderMode ? 60 : 50))
                    .foregroundColor(.yellow)
                
                Text("Oops! Something went wrong")
                    .scalableFont(size: isOlderMode ? 24 : 20, weight: .bold)
                    .multilineTextAlignment(.center)
                
                Text(error.localizedDescription)
                    .scalableFont(size: isOlderMode ? 18 : 16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Button(action: retryAction) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .scalableFont(size: isOlderMode ? 22 : 18, weight: .semibold)
                    .padding()
                    .frame(height: isOlderMode ? 60 : 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(isOlderMode ? 15 : 10)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(colorScheme == .dark ? UIColor.systemGray6 : .white))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding()
        }
    }
