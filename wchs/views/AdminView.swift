//
//  AdminView.swift
//  wchs
//
//  Created by Paul Crews on 11/11/23.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var user_model : UserModel
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
    
    @State var cards : [AdminCard] = [
        AdminCard(icon: "person.text.rectangle", card_title: "New Employee", shade: 1),
        AdminCard(icon: "person.crop.circle.badge.plus", card_title: "New Student", shade: 1),
        AdminCard(icon: "laptopcomputer", card_title: "Chromebook Service", shade: 1),
        AdminCard(icon: "wrench.and.screwdriver", card_title: "Helpdesk Service", shade: 1),
        AdminCard(icon: "cart", card_title: "New Purchase Order", shade: 1),
        AdminCard(icon: "rectangle.and.pencil.and.ellipsis", card_title: "Password Reset", shade: 1),
        AdminCard(icon: "pencil.and.list.clipboard", card_title: "New Device", shade: 1),
        AdminCard(icon: "slider.horizontal.2.square", card_title: "Hardware Inventory", shade: 2),
        AdminCard(icon: "printer", card_title: "Printer List", shade: 2),
        AdminCard(icon: "phone", card_title: "Phone List", shade: 2),
        AdminCard(icon: "person.3.sequence.fill", card_title: "Department List", shade: 2)
    ]
    
    @State var extensions : [UserExtension] = []
    
    @State var show_admin_sheet : Bool = false
    @State var admin_form_details : String = "Extension List"
    
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink {
                    FormView(sheet_id: "0")
                } label: {
                    PageHeader(title: "Admin")
                }

                ScrollView{
                    LazyVGrid(columns: getGridColumns(column: 3)) {
                        ForEach(cards.indices, id:\.self){ card in
                            NavigationLink {
                                if cards[card].shade == 1 {
                                    FormView(sheet_id: cards[card].card_title)
                                } else {
                                    AdminForms(form_shade: cards[card].shade, form_name: cards[card].card_title)
                                }
                            } label: {
                                AdminCard(icon: cards[card].icon, card_title: cards[card].card_title, shade: Double(card))
                                    .padding()
                                    .background(cards[card].shade > 1 ? .red : Color("PrimaryColor").opacity(cards[card].shade / 1))
                                    .foregroundStyle(cards[card].shade > 2 ? Color("PrimaryColor") : .white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                            }
                        }
                    }
                }
            }
        }
    }
    func updateSpreadsheet(){
        let sheet_id = "1zA6fT7TaGsjdGwQydWrQbaJnuEdMzDMZp3w6ELvVsFc"
        let range = "A2:D"
        let url = "https://sheets.googleapis.com/v4/spreadsheets/\(sheet_id)/values/\(range):append"


        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){
            data, response, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received ")
                return
            }
            
            do {
                if let json_object = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    if let body = json_object["values"] as? [[String]]{
                            for ext in body {
                                let user_extension : UserExtension = UserExtension(ext: ext[1], room: ext[0], name: "\(ext[2]) \(ext[3])", email: ext[4], phone: "/+1 718 782 9830")
                                withAnimation(.bouncy){
                                    extensions.append(user_extension)
                                    print("This is uses \(extensions.count)")
                                }
                            }
                    } else {
                        print("Doc is \(json_object["values"] ?? ""). Try again with this information.")
                    }
                    let returned_files = json_object.filter({$0.key == "files"})
                    
                    for file in returned_files{
                        print("Thisis file \(file)")
                    }
                }
            } catch {
                print("Error doing")
            }
        }
        task.resume()
    }
    func getSpreadsheet(){
        let sheet_id = "1EJD2Ugm1QUPzJ8s_tM4QzR6e_ihjON7xR83UwOhUIHo"
        let range = "A2:F"
        let url = "https://sheets.googleapis.com/v4/spreadsheets/\(sheet_id)/values/\(range)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){
            data, response, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received ")
                return
            }
            
            do {
                if let json_object = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    if let body = json_object["values"] as? [[String]]{
                            for ext in body {
                                let user_extension : UserExtension = UserExtension(ext: ext[1], room: ext[0], name: "\(ext[2]) \(ext[3])", email: ext[4], phone: "/+1 718 782 9830")
                                withAnimation(.bouncy){
                                    extensions.append(user_extension)
                                }
                            }
                    } else {
                        print("Spreadheet Doc is \(json_object["values"] ?? "")")
                    }
                }
            } catch {
                print("Error doing")
            }
        }
        task.resume()
    }
}

#Preview {
    AdminView()
}
