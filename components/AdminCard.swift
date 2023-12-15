//
//  AdminCard.swift
//  wchs
//
//  Created by Paul Crews on 11/11/23.
//

import SwiftUI

struct AdminCard: View {
    @State var new_employee : GoogleContact = GoogleContact(
        name: "",
        photo: "",
        email: "",
        department: "Operations",
        title: "",
        is_admin: false,
        phone: "100",
        room: "198",
        kind: "employee"
    )
    @State var add_new_employee : Bool = false
    @State var add_new_student  : Bool = false
    @State var add_photo        : Bool = false
    @State var add_department   : Bool = false
    @State var add_phone        : Bool = false
    @State var add_room         : Bool = false
    @State var icon             : String
    @State var card_title       : String
    @State var shade            : Double
    @State var show_admin_form  : Bool = false
    
    
    var body: some View {
        VStack{
            Image(systemName: icon)
                .font(.largeTitle)
            Button {
                withAnimation(.bouncy){
                    show_admin_form.toggle()
                }
            } label: {
                Text(card_title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding()
            .foregroundStyle(.white.opacity(0.75))
            
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
        .padding()
        .foregroundStyle(.white)
        .frame(width: 200, height: 250)
    }
}

#Preview {
            AdminCard(icon: "person.circle", card_title: "Test", shade: 0.9)
}
