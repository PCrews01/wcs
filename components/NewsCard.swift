//
//  NewsCard.swift
//  wchs
//
//  Created by Paul Crews on 11/5/23.
//

import SwiftUI

struct NewsCard: View {
    @State var image            :   String
    @State var title            :   String
    @State var story            :   String
    @State var week             :   String
    @State var article_images   :   [String]?
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 150, maxHeight: 200, alignment: .center)
            }
            Divider()
                .overlay(.white)
            HStack{
                Text("\(week.replacingOccurrences(of: "a", with: ""))")
                    .font(.caption)
                    .foregroundStyle(.white)
                Spacer()
                    Text("Read More")
                        .font(.caption)
                .padding(5)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
    
            }
        }
        .padding()
        .background(Color("PrimaryColor")).clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}

#Preview {
    NewsCard(image: "tree", title: "Story of OJ", story: "", week: "")
}
