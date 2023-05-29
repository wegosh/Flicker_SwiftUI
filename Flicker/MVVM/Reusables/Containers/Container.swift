//
//  Container.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import SwiftUI

struct Container<Content: View>: View {
    let iconSysName: String
    let title: String
    let content: () -> Content
    
    init(iconSysName: String, title: String, @ViewBuilder content: @escaping () -> Content) {
        self.iconSysName = iconSysName
        self.title = title
        self.content = content
    }
    
    var body: some View {
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

struct Container_Previews: PreviewProvider {
    static var previews: some View {
        Container(iconSysName: "chevron", title: "Chevron", content: {
            Text("Test")
        })
    }
}
