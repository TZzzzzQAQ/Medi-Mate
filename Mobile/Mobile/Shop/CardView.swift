import SwiftUI

struct CardView: View {
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    let places: [Place] = [
        Place(fact: "In 2022/23, 86.2% of adults reported they were in 'good health', which is defined as good, very good or excellent health. This level of good health is similar to levels reported over the previous 5 years."),
        Place(fact: "The rate of daily vaping increased over the past five years from 2.6% in 2017/18 to 9.7% in 2022/23."),
        Place(fact: "One in five children (21.3%) lived in households where food ran out often or sometimes in the 12 months prior to the 2022/23 survey. This is an increase from the previous two years (14.4% in 2021/22 and 14.9% in 2020/21), but similar to other years since 2011/12.")
    ]
    
    var body: some View {
        VStack {
            headerView
            cardsView
        }
        .background(Color(UIColor.systemBackground))
    }
    
    private var headerView: some View {
        HStack {
            Text("Do you know")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.primary)
            Image(.bookSolid)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
        }
        .padding(.top, 70)
    }
    
    private var cardsView: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(places.indices, id: \.self) { index in
                    CardDetailView(place: places[index])
                        .frame(width: geometry.size.width)
                        .rotation3DEffect(
                            .degrees(Double(index - currentIndex) * 90 + Double(dragOffset / geometry.size.width) * 90),
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
            }
            .offset(x: -CGFloat(currentIndex) * geometry.size.width + dragOffset)
            .gesture(dragGesture(geometry: geometry))
        }
        .animation(.spring(), value: currentIndex)
    }
    
    private func dragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let threshold = geometry.size.width * 0.25
                withAnimation(.spring()) {
                    if value.translation.width > threshold && currentIndex > 0 {
                        currentIndex -= 1
                    } else if value.translation.width < -threshold && currentIndex < places.count - 1 {
                        currentIndex += 1
                    }
                    dragOffset = 0
                }
            }
    }
}

struct CardDetailView: View {
    let place: Place
    
    var body: some View {
        VStack {
            Text(place.fact)
                .font(.system(size: 24))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 500)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(40)
    }
}

struct Place: Identifiable {
    let id = UUID()
    let fact: String
}

#Preview {
    CardView()
}
