import SwiftUI

struct CareCompareView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    let productIds: [String]
    @State private var expandedCard: String?
    @State private var showingAIInsights = false
    @State private var animationOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 40) {
                        if !viewModel.isLoading && !viewModel.comparisons.isEmpty {
                            PriceComparisonView(comparisons: viewModel.comparisons)
                                .padding(.horizontal)

                            ForEach(viewModel.comparisons, id: \.productId) { comparison in
                                CareComparisonCard(comparison: comparison, isExpanded: expandedCard == comparison.productId)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            expandedCard = (expandedCard == comparison.productId) ? nil : comparison.productId
                                        }
                                    }
                            }

                            aiInsightsButton

                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    .padding()
                }

                if viewModel.isLoading {
                    analyzingProductsAnimation
                } else if viewModel.comparisons.isEmpty {
                    EmptyStateView()
                }
            }
            .navigationTitle("Care Comparison")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.fetchComparisons(productIds: productIds)
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animationOffset = 20
            }
        }
        .sheet(isPresented: $showingAIInsights) {
            AIInsightsView(comparisons: viewModel.comparisons)
        }
    }

    private var aiInsightsButton: some View {
        Button(action: {
            showingAIInsights = true
        }) {
            HStack {
                Image(systemName: "brain.head.profile")
                Text("AI Insights")
            }
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(25)
        }
    }

    private var analyzingProductsAnimation: some View {
        VStack(spacing: 30) {
            Text("Analyzing")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.blue)

            Text("Care Products")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.blue)
                .offset(y: animationOffset)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2.0)
        }
        .frame(width: 250, height: 250)
        .background(Color.white.opacity(0.9))
        .cornerRadius(25)
        .shadow(radius: 15)
    }
}

struct CareComparisonCard: View {
    let comparison: Comparison
    let isExpanded: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            AsyncImage(url: URL(string: comparison.imageSrc)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 250, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .center, spacing: 15) {
                Text(comparison.productName)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                Text(comparison.productPrice)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.blue)
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 15) {
                    CareDetailRow(title: "Common Use", detail: comparison.commonUse)
                    CareDetailRow(title: "Warnings", detail: comparison.warnings)
                }
                .transition(.opacity)
            }

            Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                .foregroundColor(.blue)
                .font(.system(size: 30))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
    }
}

struct CareDetailRow: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.gray)
            Text(detail)
                .font(.system(size: 20))
                .foregroundColor(.black)
        }
    }
}

// Note: PriceComparisonView, AIInsightsView, and EmptyStateView remain the same as in the original ComparisonView
