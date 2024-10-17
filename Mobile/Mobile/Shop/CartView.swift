import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    @State private var showingLocationSelection = false
    @Namespace private var animation

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    header
                    
                    if cartManager.items.isEmpty {
                        emptyCartView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(cartManager.items) { item in
                                    CartItemCard(item: item)
                                        .transition(.opacity)
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 16) {
                                totalSection
                                proceedToLocationSelectionButton
                            }
                            .padding(.horizontal)
                            .padding(.top, 24)
                            .padding(.bottom, geometry.safeAreaInsets.bottom + (isOlderMode ? 100 : 80))
                        }
                        .refreshable {
                            // Add refresh functionality if needed
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingLocationSelection) {
            LocationSelectionView()
        }
    }
    
    private var header: some View {
        HStack {
            Text("Your Cart")
                .font(.system(size: isOlderMode ? 32 : 32, weight: .bold))
                .scalableFont(size: isOlderMode ? 32 : 28)
                .ignoresSafeArea()
                .padding(.top, 55)
            
            Spacer()
            
//            Text("\(cartManager.items.count) items")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
    }
    
    private var emptyCartView: some View {
        VStack(spacing: isOlderMode ? 30 : 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: isOlderMode ? 84 : 60))
                .foregroundColor(.gray)
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)
                .scalableFont(size: isOlderMode ? 28 : 22)
            Text("Add some items to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .scalableFont(size: isOlderMode ? 22 : 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
    
    private var totalSection: some View {
        HStack {
            Text("Total")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 28 : 20)
            Spacer()
            Text(formatPrice(cartManager.totalPrice))
                .font(.title2)
                .fontWeight(.bold)
                .scalableFont(size: isOlderMode ? 32 : 24)
        }
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    private var proceedToLocationSelectionButton: some View {
            Button(action: {
                showingLocationSelection = true
            }) {
                Text("Proceed to Click & Collect")
                    .font(.headline)
                    .scalableFont(size: isOlderMode ? 26 : 18)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isOlderMode ? 20 : 15)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        
        private func formatPrice(_ price: String) -> String {
            guard let doublePrice = Double(price) else {
                return "Invalid Price"
            }
            return String(format: "$%.2f", doublePrice)
        }
    }
struct CartItemCard: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    
    var body: some View {
        HStack(spacing: 16) {
            productImage
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.product.productName)
                    .font(.headline)
                    .scalableFont(size: isOlderMode ? 22 : 18)
                    .lineLimit(2)
                
                Text("$\(item.product.productPrice)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .scalableFont(size: isOlderMode ? 20 : 16)
                
                quantityControl
            }
            
            Spacer()
            
            removeButton
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var productImage: some View {
        AsyncImage(url: URL(string: item.product.imageSrc)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: isOlderMode ? 100 : 80, height: isOlderMode ? 100 : 80)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
    }
    
    private var quantityControl: some View {
        HStack {
            Button(action: { updateQuantity(-1) }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.blue)
            }
            
            Text("\(item.quantity)")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 22 : 18)
                .frame(minWidth: 30)
            
            Button(action: { updateQuantity(1) }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
            }
        }
    }

    private var removeButton: some View {
        Button(action: {
            withAnimation {
                cartManager.removeFromCart(item.product)
            }
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
                .scalableFont(size: isOlderMode ? 22 : 18)
                .padding(8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private func updateQuantity(_ change: Int) {
        let newQuantity = max(1, item.quantity + change)
        cartManager.addOrUpdateItem(item.product, quantity: newQuantity)
    }
}
