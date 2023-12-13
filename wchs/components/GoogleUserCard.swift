//
//  GoogleUserCard.swift
//  wchs
//
//  Created by Paul Crews on 11/5/23.
//

import SwiftUI

struct GoogleUserCard: View {
    @State var contact : GoogleContact
    @State var  id : String
    var body: some View {
        
        VStack {
            HStack{
                VStack(alignment:.leading){
                    Text(contact.name)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(contact.email)
                        .foregroundStyle(.white)
                        .font(.caption)
                    
                    Text(contact.title)
                        .foregroundStyle(.white)
                        .font(.caption)
                    
                    Text(contact.department ?? "")
                        .foregroundStyle(.white)
                        .font(.caption)
                    
                    Text(contact.phone ?? "P: +1 (718) 782 9830")
                        .foregroundStyle(.white)
                        .font(.caption)
                    
                    Text(contact.room ?? "E: 198")
                        .foregroundStyle(.white)
                        .font(.caption)
                }
                Spacer()
                if (contact.photo!.count > 1) {
                    AsyncImage(url: URL(string: contact.photo!)) { image in
                        image.image?
                            .resizable()
                            .frame(maxWidth: 100, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
            .background(Color("PrimaryColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))

            Divider()
                .overlay(.white)
            HStack{
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("Read More")
                        .font(.caption)
                })
                .padding(5)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            }
        }
    }
}
