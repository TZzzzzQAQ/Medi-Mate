import SwiftUI

struct LocationView: View {
    let location: StoreLocation
    let productLocation: ProductLocationData
    @State private var isAnimating = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Image(.store)
                    .resizable()
                    .scaledToFit()
                locationIcon
            }
            .frame(width: 350, height: 350)
            .border(Color.black)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Pharmacy: \(productLocation.pharmacyName)")
                Text("Stock Quantity: \(productLocation.stockQuantity)")
                Text("Shelf Number: \(productLocation.shelfNumber)")
                Text("Shelf Level: \(productLocation.shelfLevel)")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Product Location")
        .onAppear {
            withAnimation(.linear(duration: 0.6).repeatForever()) {
                isAnimating = true
            }
        }
    }
    
    @ViewBuilder
    private var locationIcon: some View {
        Image(systemName: "arrowshape.down.fill")
            .foregroundColor(.red)
            .font(.system(size: 30))
            .position(positionForLocation(location))
            .offset(y: isAnimating ? -5 : 5)
            .animation(.easeInOut(duration: 0.6).repeatForever(), value: isAnimating)
    }
    
    private func positionForLocation(_ location: StoreLocation) -> CGPoint {
        switch location {
        case .a: return CGPoint(x: 85, y: 170)
        case .b: return CGPoint(x: 120, y: 150)
        case .c: return CGPoint(x: 170, y: 130)
        case .d: return CGPoint(x: 140, y: 210)
        case .e: return CGPoint(x: 200, y: 170)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: .a, productLocation: ProductLocationData(pharmacyName: "Test Pharmacy", stockQuantity: 10, shelfNumber: "A", shelfLevel: 2))
    }
}
