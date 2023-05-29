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
    
    private var navigationTitle: String {
        let resultsText = "Results for: \(viewModel.searchForText)"
        return viewModel.searchForText.isEmpty ? "Recent Images" : resultsText
    }
    
    private var promptTitle: String {
        switch viewModel.pickerMode {
        case .people:
            return "Search for people"
        case .tags:
            return "Search for tags - \(viewModel.tagMode.description)"
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let user = viewModel.personResponse {
                if !viewModel.searchForText.isEmpty,
                   viewModel.pickerMode == .people {
                    PersonDetailCard(nsID: user.nsID,
                                     imageURL: user.imageURL,
                                     username: user.username.content,
                                     realName: user.realname.content,
                                     location: user.location.content,
                                     description: user.description.content,
                                     photoCount: user.photos.count.content)
                    .padding(20)
                    .onTapGesture {
                        viewModel.selectProfile(nsID: user.nsID,
                                                username: user.username.content,
                                                realName: user.realname.content,
                                                location: user.location.content,
                                                iconServer: user.iconServer,
                                                iconFarm: user.iconFarm)
                    }
                }
            } else if viewModel.pickerMode == .people,
                      !viewModel.searchForText.isEmpty,
                      case .error(message: let message) = viewModel.state {
                Text(message)
            }
            LazyVStack(spacing: 10) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 1)
                
                ForEach(viewModel.pictures.uniqueElements()) { item in
                    PictureDetailCard(imageURL: item.imageURL(size: .medium),
                                      profileURL: item.profileIconURL,
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
            }
            .padding(20)
            
            if viewModel.state == .loading {
                ProgressView()
            }
        }
        .navigationTitle(navigationTitle)
        .navigationDestination(isPresented: $viewModel.showImageDetails, destination: {
            ImageDetailView(imageTitle: viewModel.selectedResponse?.title ?? "",
                            photoID: viewModel.selectedResponse?.id ?? "",
                            secret: viewModel.selectedResponse?.secret)
        })
        .navigationDestination(isPresented: $viewModel.showUserPhotos, destination: {
            UserImageListView(owner: $viewModel.selectedOwnerResponse)
        })
        .searchable(text: viewModel.transformSearch(),
                    placement: .toolbar,
                    prompt: promptTitle)
        .toolbar {
            Button(action: {
                viewModel.toggleSearchMode.toggle()
            }, label: {
                Text("Search mode")
            })
        }
        .onAppear {
            Task {
                await viewModel.fetchImages()
            }
        }
        .refreshable {
            Task {
                await viewModel.resetPageAsync()
                await viewModel.fetchImages()
            }
        }
        .sheet(isPresented: $viewModel.toggleSearchMode, content: {
            SearchModeView(searchMode: $viewModel.pickerMode, tagMode: $viewModel.tagMode)
                .presentationDetents([.height(200)])
        })
    }
}

struct SearchModeView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var searchMode: ImageListViewModel.PickerMode
    @Binding var tagMode: TagSearchMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Please select search mode")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Done")
                })
            }
            
            
            Picker("Please select search mode", selection: $searchMode, content: {
                Text("Tags")
                    .tag(ImageListViewModel.PickerMode.tags)
                
                Text("People")
                    .tag(ImageListViewModel.PickerMode.people)
            })
            .pickerStyle(.segmented)
            
            if searchMode == .tags {
                Picker("Select tag picking mode", selection: $tagMode, content: {
                    Text("Any matching tags")
                        .tag(TagSearchMode.anyMatching)
                    
                    Text("All matching tags")
                        .tag(TagSearchMode.allMatching)
                })
                .pickerStyle(.segmented)
            }
            
            Spacer()
        }
        .padding(20)
    }
}

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack(root: {
            ImageListView()
        })
    }
}
