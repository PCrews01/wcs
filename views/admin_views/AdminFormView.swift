//
//  AdminFormView.swift
//  wchs
//
//  Created by Paul Crews on 11/18/23.
//

import SwiftUI

struct AdminFormView: View {
    @State var form : FormEntry
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
 
 {
     Text("Admin sheet \(admin_form_details)")
     if admin_form_details.count > 1 {
         if admin_form_details != "Extension List"{
             AdminForms(form_name: cards[card].card_title)
         } else {
             if extensions.count == 1 {
                 Table(extensions) {
                     TableColumn("Name", value: \.name)
                         .width(200)
                     TableColumn("Email", value: \.email)
                         .width(200)
                     TableColumn("Room", value: \.room)
                     TableColumn("Extension", value: \.ext)
                 }
             }
         }
     }
 }
 */
