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
            LazyVStack(spacing: 10) {
                ForEach(viewModel.pictures.uniqueElements()) { item in
                    PictureDetailCard(imageURL: item.imageURL(size: .medium),
                                      profileURL: item.profileIconURL(),
                                      username: item.username,
                                      userNSID: item.owner,
                                      tags: item.tags,
                                      imageTapped: {
                        viewModel.selectImage(item)
                    },
                                      profileTapped: {
                        viewModel.selectProfile(from: item)
                    })
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: item)
                        }
                }
                
                if viewModel.state == .loading {
                    ProgressView()
                }
            }
            .padding(20)
        }
        .navigationTitle("Dashboard")
        .navigationDestination(isPresented: $viewModel.showImageDetails, destination: {
            ImageDetailView(imageTitle: viewModel.selectedResponse?.title ?? "",
                            photoID: viewModel.selectedResponse?.id ?? "",
                            secret: viewModel.selectedResponse?.secret)
        })
        .navigationDestination(isPresented: $viewModel.showUserPhotos, destination: {
            UserImageListView(owner: $viewModel.selectedOwnerResponse)
        })
        .onAppear {
            Task {
                await viewModel.fetchImages()
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
