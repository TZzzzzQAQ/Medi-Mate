import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthenticationView()
    @StateObject private var tabBarManager = TabBarManager()
    @StateObject private var cartManager = CartManager()
    @StateObject private var homeViewModel = HomeVM()
    @AppStorage("isCareMode") private var isOlderMode = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("background").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                switch tabBarManager.selectedIndex {
                case 0:
                    HomeView(viewModel: homeViewModel)
                case 1:
                    CardView()
                case 2:
                    CartView()
                case 3:
                    NavigationView {
                        StoreLocationsView()
                    }
                case 4:
                    if authViewModel.isLoginSuccessed {
                        AccountView(authViewModel: authViewModel)
                    } else {
                        LoginView(authViewModel: authViewModel)
                    }
                default:
                    Text("Unknown Content")
                }
                Spacer()
            }
            
            CustomTabBar()
        }
        .environmentObject(tabBarManager)
        .environmentObject(authViewModel)
        .environmentObject(cartManager)
        .environmentObject(homeViewModel)
        .onChange(of: authViewModel.isLoginSuccessed) { oldValue, newValue in
            if newValue {
                tabBarManager.selectedIndex = 0
            }
        }
        .environment(\.fontSizeMultiplier, isOlderMode ? 1.25 : 1.0)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
