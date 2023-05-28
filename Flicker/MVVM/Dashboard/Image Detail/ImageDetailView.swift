//
//  ImageDetailView.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageDetailView: View {
    @StateObject private var viewModel: ImageDetailViewModel = .init()
    let imageTitle: String
    let photoID: String
    let secret: String?
    
    private var dateFormat: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy - HH:mm"
        return dateFormat
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                if viewModel.state == .loading {
                    ProgressView()
                } else {
                    if case .error(message: let message) = viewModel.state {
                        Text(message)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                    }
                    
                    if let details = viewModel.imageDetails {
                        WebImage(url: details.imageURL(size: .medium))
                            .resizable()
                            .scaledToFit()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top, spacing: 15) {
                                WebImage(url: details.owner.profileIconURL)
                                    .avatar
                                
                                VStack(alignment: .leading) {
                                    Text(details.owner.realName)
                                        .font(.system(size: 20, weight: .bold))
                                    Text(details.owner.username)
                                }
                            }
                            .padding(.top, 10)
                            
                            container(iconSysName: "photo", title: "Details", content: {
                                Group {
                                    Text("Title: ")
                                        .font(.system(size: 18, weight: .bold))
                                    + Text(imageTitle)
                                        .font(.system(size: 18))
                                    
                                    Text("Description: ")
                                        .font(.system(size: 18, weight: .bold))
                                    + Text(imageTitle)
                                        .font(.system(size: 18))
                                }
                            })
                            
                            container(iconSysName: "calendar", title: "Dates", content: {
                                Group {
                                    Text("Posted: ")
                                        .font(.system(size: 18, weight: .bold))
                                    + Text(dateFormat.string(from: details.dates.posted))
                                        .font(.system(size: 18))
                                    
                                    Text("Taken: ")
                                        .font(.system(size: 18, weight: .bold))
                                    + Text(dateFormat.string(from: details.dates.taken))
                                        .font(.system(size: 18))
                                }
                            })
                        }
                        .padding([.horizontal, .bottom], 10)
                    }
                }
            }
            .foregroundColor(.black.opacity(0.8))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(imageTitle)
        .onAppear {
            viewModel.fetchDetails(photoID, secret: secret)
        }
    }
}

extension ImageDetailView {
    @ViewBuilder
    func container<Content: View>(iconSysName: String, title: String, content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconSysName)
                    .font(.system(size: 28))
                    .foregroundColor(.gray.opacity(0.5))
                
                Text(title)
                    .font(.system(.title3, weight: .medium))
            }
            
            Divider()
            
            content()
                .padding(.leading, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.2), radius: 10, y: 5)
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(imageTitle: "Image title", photoID: "52932061761", secret: "f695b70c24")
    }
}
