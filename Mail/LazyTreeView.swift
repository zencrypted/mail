import SwiftUI

struct LazyTreeView: View {
    var roots: [RMKDocument]
    var viewModel: DashboardViewModel

    var body: some View {
        List {
            ForEach(roots) { root in
                LazyTreeRow(document: root, viewModel: viewModel)
            }
        }
        .listStyle(.sidebar)
        .animation(.default, value: roots.count)
    }
}
