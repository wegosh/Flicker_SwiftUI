//
//  ImageListView.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageListView: View {
    @StateObject private var viewModel: ImageListViewModel = .init()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.pictures) { item in
                    WebImage(url: item.imageURL(size: .medium))
                }
                
                if viewModel.imagesHaveNextPage {
                    ProgressView()
                        .task {
                            await viewModel.fetchImages()
                        }
                }
            }
        }
        .refreshable {
            Task {
                await viewModel.resetPage()
                await viewModel.fetchImages()
            }
        }
    }
}

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        ImageListView()
    }
}
