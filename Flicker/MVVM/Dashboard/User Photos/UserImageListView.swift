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
                HStack(alignment: .top, spacing: 15) {
                    WebImage(url: owner.profileIconURL())
                        .avatar
                    
                    VStack(alignment: .leading) {
                        Text(owner.realName)
                            .font(.system(size: 20, weight: .bold))
                        Text(owner.username)
                    }
                }
                
                Spacer()
                
                LazyVGrid(columns: [.init(), .init()], content: {
                    ForEach(viewModel.pictures) { item in
                        WebImage(url: item.imageURL(size: .small240px))
                    }
                })
            }
        }
        .padding(20)
        .navigationTitle(owner?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
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
