//
//  PersonDetailCard.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PersonDetailCard: View {
    let nsID: String
    let imageURL: URL?
    let username: String
    let realName: String
    let location: String
    let description: String
    let photoCount: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 15) {
                WebImage(url: imageURL)
                    .avatar
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(realName)
                        .font(.system(size: 20, weight: .bold))
                    Text(username)
                    if !location.isEmpty {
                        HStack {
                            Image(systemName: "map.fill")
                            Text(location)
                        }
                        .foregroundColor(.gray)
                    }
                    if let photoCount,
                       !photoCount.isEmpty {
                        HStack {
                            Image(systemName: "photo.fill")
                            Text("Photos: ")
                            + Text(photoCount)
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            if !description.isEmpty {
                Text(description)
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.horizontal, 10)
            }
        }
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.2), radius: 10, y: 5)
    }
}

struct PersonDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailCard(nsID: PersonResponse.previewContent().nsID,
                         imageURL: PersonResponse.previewContent().imageURL,
                         username: PersonResponse.previewContent().username.content,
                         realName: PersonResponse.previewContent().realname.content,
                         location: PersonResponse.previewContent().location.content,
                         description: PersonResponse.previewContent().description.content,
                         photoCount: PersonResponse.previewContent().photos.count.content)
    }
}
