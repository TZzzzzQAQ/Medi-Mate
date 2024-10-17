//import SwiftUI
//
//// MARK: - ProductPriceInfo
//struct ProductPriceInfo: Identifiable {
//    let id = UUID()
//    let name: String
//    let price: Double
//}
//
//// MARK: - LinePriceComparisonView
//import SwiftUI
//
//struct PriceComparisonListView: View {
//    let products: [ProductPriceInfo]
//    
//    private var sortedProducts: [ProductPriceInfo] {
//        products.sorted { $0.price < $1.price }
//    }
//    
//    private var lowestPrice: Double {
//        sortedProducts.first?.price ?? 0
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Price Comparison")
//                .font(.title2)
//                .fontWeight(.bold)
//            
//            ForEach(sortedProducts) { product in
//                PriceRow(product: product, lowestPrice: lowestPrice)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
//    }
//}
//
//struct PriceRow: View {
//    let product: ProductPriceInfo
//    let lowestPrice: Double
//    
//    private var priceDifference: Double {
//        product.price - lowestPrice
//    }
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text(product.name)
//                    .font(.headline)
//                if priceDifference > 0 {
//                    Text("+$\(priceDifference, specifier: "%.2f")")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//            }
//            
//            Spacer()
//            
//            Text("$\(product.price, specifier: "%.2f")")
//                .font(.title3)
//                .fontWeight(.semibold)
//                .foregroundColor(product.price == lowestPrice ? .green : .primary)
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal, 12)
//        .background(product.price == lowestPrice ? Color.green.opacity(0.1) : Color.clear)
//        .cornerRadius(8)
//    }
//}
//
//struct PriceComparisonListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PriceComparisonListView(products: [
//            ProductPriceInfo(name: "Product A", price: 79.99),
//            ProductPriceInfo(name: "Product B", price: 149.99),
//            ProductPriceInfo(name: "Product C", price: 79.99),
//            ProductPriceInfo(name: "Product D", price: 199.99),
//            ProductPriceInfo(name: "Product E", price: 129.99)
//        ])
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
