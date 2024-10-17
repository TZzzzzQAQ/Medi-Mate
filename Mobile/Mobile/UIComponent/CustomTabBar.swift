import SwiftUI
import AnimatedTabBar

class TabBarManager: ObservableObject {
    @Published var selectedIndex = 0
}

struct CustomTabBar: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @AppStorage("isOlderMode") private var isOlderMode = false
    let icons = ["house", "book.pages","cart", "map", "person.crop.circle"]
    
    var body: some View {
        HStack {
            AnimatedTabBar(selectedIndex: $tabBarManager.selectedIndex, views: icons.indices.map { index in
                wiggleButtonAt(index)
            })
            .barColor(Color.white.opacity(0.9))
            .selectedColor(.black)
            .unselectedColor(.gray)
            .ballColor(Color("bar"))
            .verticalPadding(isOlderMode ? 40 : 30)
            .ballTrajectory(.parabolic)
            .ballAnimation(.easeOut(duration: 0.4))
            .frame(height: isOlderMode ? 100 : 80)  // Increase the overall height in Older Mode
        }
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .transition(.move(edge: .bottom))
    }
    
    private func wiggleButtonAt(_ index: Int) -> some View {
        WiggleButton(image: Image(systemName: icons[index]), maskImage: Image(systemName: "\(icons[index]).fill"), isSelected: index == tabBarManager.selectedIndex)
            .scaleEffect(isOlderMode ? 3.0 : 1.5)  // Increase scale in Older Mode
            .frame(width: isOlderMode ? 60 : 40, height: isOlderMode ? 60 : 40)  // Increase touch target in Older Mode
            .onTapGesture {
                tabBarManager.selectedIndex = index
            }
    }
}

// Preview
struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
            .environmentObject(TabBarManager())
    }
}
