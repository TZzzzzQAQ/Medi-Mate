import SwiftUI

struct SearchResultsContainer: View {
    @ObservedObject var viewModel: HomeVM
    @AppStorage("isCareMode") private var isCareMode = false

    var body: some View {
        Group {
            if isCareMode {
                CareResultView(HomeVM: viewModel)
            } else {
                ResultsView(HomeVM: viewModel)
            }
        }
    }
}
