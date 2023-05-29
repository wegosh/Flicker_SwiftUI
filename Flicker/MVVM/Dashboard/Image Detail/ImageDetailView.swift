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
                            
                            Container(iconSysName: "photo", title: "Details", content: {
                                Group {
                                    containerCell(title: "Title", detail: imageTitle)
                                    containerCell(title: "Description", detail: details.description.content)
                                }
                            })
                            
                            Container(iconSysName: "calendar", title: "Dates", content: {
                                Group {
                                    containerCell(title: "Posted", detail: dateFormat.string(from: details.dates.posted))
                                    containerCell(title: "Taken", detail: dateFormat.string(from: details.dates.taken))
                                }
                            })
                            
                            if let exif = viewModel.exifData,
                               exif.exif.contains(where: {$0.tag != .unknown}) {
                                Container(iconSysName: "camera", title: "Image details", content: {
                                    ForEach(exif.exif, id: \.id, content: { item in
                                        if item.tag != .unknown {
                                            containerCell(title: item.label, detail: item.raw.content)
                                        }
                                    })
                                })
                            }
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
    func containerCell(title: String, detail: String) -> some View {
        Group {
            Text(title)
                .font(.system(size: 18, weight: .bold))
            + Text(": ")
            + Text(detail)
                .font(.system(size: 18))
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(imageTitle: "Image title", photoID: "52932061761", secret: "f695b70c24")
    }
}
