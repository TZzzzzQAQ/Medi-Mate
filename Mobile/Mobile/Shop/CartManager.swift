import Foundation

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var selectedStore: Location?
    
    

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearCart), name: .userDidLogout, object: nil)
    }

    func addToCart(_ product: ProductDetails, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.productId == product.productId }) {
            items[index].quantity = quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
        objectWillChange.send()
    }

    func updateQuantity(for product: ProductDetails, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.productId == product.productId }) {
            items[index].quantity = max(0, quantity)
            if items[index].quantity == 0 {
                items.remove(at: index)
            }
        } else if quantity > 0 {
            items.append(CartItem(product: product, quantity: quantity))
        }
        objectWillChange.send()
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func removeFromCart(_ product: ProductDetails) {
        items.removeAll { $0.product.productId == product.productId }
        objectWillChange.send()
    }
    func addOrUpdateItem(_ product: ProductDetails, quantity: Int) {
            if let index = items.firstIndex(where: { $0.product.productId == product.productId }) {
                items[index].quantity = max(1, quantity)
            } else {
                items.append(CartItem(product: product, quantity: max(1, quantity)))
            }
            objectWillChange.send()
        }
    
    func removeItem(_ product: ProductDetails) {
        items.removeAll { $0.product.productId == product.productId }
        objectWillChange.send()
    }
    
    func getQuantity(for productId: String) -> Int {
        return items.first(where: { $0.product.productId == productId })?.quantity ?? 0
    }


    var totalPrice: String {
        items.reduce("0") { result, item in
            guard let price = Double(item.product.productPrice),
                  let total = Double(result) else {
                return result
            }
            return String(total + (price * Double(item.quantity)))
        }
    }

    @objc func clearCart() {
        DispatchQueue.main.async {
            self.items.removeAll()
            self.selectedStore = nil
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func prepareOrder(userId: String) -> [String: Any]? {
        guard let store = selectedStore, !items.isEmpty else {
            return nil
        }
        
        let orderItems = items.map { item in
            return [
                "productId": item.product.productId,
                "quantity": item.quantity,
                "price": Double(item.product.productPrice) ?? 0.0
            ]
        }
        
        let totalAmount = items.reduce(0.0) { total, item in
            total + (Double(item.product.productPrice) ?? 0.0) * Double(item.quantity)
        }
        
        return [
            "userId": userId,
            "pharmacyId": store.id,
            "amount": totalAmount,
            "orderItem": orderItems
        ]
    }
    
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: ProductDetails
    var quantity: Int
}

struct Product1: Identifiable {
    let id: String
    let productName: String
    let productPrice: String
    let imageSrc: String
    // ... other properties ...
}
