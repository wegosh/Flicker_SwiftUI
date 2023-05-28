//
//  UserImageList.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserImageListView: View {
    @StateObject private var viewModel: UserImageListViewModel = .init()
    @Binding var owner: OwnerResponse?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let owner {
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top, spacing: 15) {
                        WebImage(url: owner.profileIconURL)
                            .avatar
                        
                        VStack(alignment: .leading) {
                            Text(owner.realName)
                                .font(.system(size: 20, weight: .bold))
                            Text(owner.username)
                        }
                    }
                    .padding(10)
                    
                    Text("User images:")
                        .font(.system(size: 24, weight: .medium))
                }
                
                .padding(10)
                
                Spacer()
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [.init(), .init()], content: {
                        ForEach(viewModel.pictures) { item in
                            RoundedRectangle(cornerRadius: 0)
                                .aspectRatio(1.0 , contentMode: .fill)
                                .foregroundColor(.gray.opacity(0.3))
                                .overlay {
                                    WebImage(url: item.imageURL(size: .small240px))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(minHeight: 0, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fill)
                                        .clipped()
                                        .onAppear {
                                            viewModel.loadMoreIfNeeded(currentItem: item)
                                        }
                                }
                                .onTapGesture {
                                    viewModel.selectImage(item)
                                }
                        }
                    })
                }
            }
        }
        .navigationTitle(owner?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.showImageDetails, destination: {
            ImageDetailView(imageTitle: viewModel.selectedResponse?.title ?? "",
                            photoID: viewModel.selectedResponse?.id ?? "",
                            secret: viewModel.selectedResponse?.secret)
        })
        .onAppear {
            Task {
                guard let owner else { return }
                viewModel.userID = owner.nsID
                await viewModel.fetchImages()
            }
        }
    }
}

struct UserImageListView_Previews: PreviewProvider {
    static var previews: some View {
        UserImageListView(owner: .constant(.previewContent()))
    }
}
