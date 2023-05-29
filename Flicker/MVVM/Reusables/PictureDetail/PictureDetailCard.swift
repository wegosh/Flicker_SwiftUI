//
//  PictureDetail.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PictureDetailCard: View {
    let imageURL: URL?
    let profileURL: URL?
    let username: String
    let userNSID: String
    let tags: String
    let imageTapped: () -> Void
    let profileTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            WebImage(url: imageURL)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    imageTapped()
                }
            
            HStack(alignment: .top, spacing: 15) {
                WebImage(url: profileURL)
                    .avatar
                
                VStack(alignment: .leading) {
                    Text(username)
                        .font(.system(size: 20, weight: .bold))
                    Text(userNSID)
                    
                    if !tags.isEmpty {
                        Text("Tags: ")
                        + Text(tags.split(separator: " ").joined(separator: ", "))
                    }
                }
            }
            .padding([.horizontal, .bottom], 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .onTapGesture {
                profileTapped()
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(2)
        .shadow(color: .gray.opacity(0.1), radius: 10, y: 5)
    }
}

struct PictureDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        PictureDetailCard(imageURL: URL(string: "https://picsum.photos/1000/800"),
                      profileURL: URL(string: "https://farm5.staticflickr.com/4450/buddyicons/110072918@N08.jpg"),
                      username: "User1232",
                      userNSID: "User 123",
                      tags: "aaa bbb ccc",
        imageTapped: {
            print("image tap")
        }, profileTapped: {
            print("profile tap")
        })
    }
}
