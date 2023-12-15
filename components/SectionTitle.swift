//
//  SectionTitle.swift
//  wchs
//
//  Created by Paul Crews on 11/5/23.
//

import SwiftUI

struct SectionTitle: View {
    @State var title : String
    var body: some View {
            HStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(Color("PrimaryColor").opacity(0.75))
            .foregroundStyle(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 2.0)
    }
}

#Preview {
    SectionTitle(title: "Test")
}
