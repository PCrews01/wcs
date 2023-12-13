//
//  ContactsView.swift
//  wchs
//
//  Created by Paul Crews on 11/4/23.
//

import SwiftUI
import GoogleSignIn

struct ContactsView: View {
    @EnvironmentObject var user_model : UserModel
    @State var contacts : [GoogleContact] = []
    @State var student_list: [GoogleContact] = []
    @State var employee_list : [GoogleContact] = []
    @State var search_term : String = ""
    @State var show_students : Bool = false
    @State var show_employees : Bool = false
    @State var show_all : Bool = true
    @State var show_details : Bool = false
    @State var contact_details : GoogleContact = GoogleContact(name: "", email: "", title: "", is_admin: false, kind: "")
    
    var body: some View {
        ScrollViewReader { scroller in
            VStack{
                PageHeader(title: "Directory")
                if contacts.count < 1 {
                    VStack{
                        ProgressView {
                            Text("Loading staff directory")
                                .onAppear() {
                                    if contacts.count < 1{
                                        getContacts()
                                    }
                                }
                        }
                    }
                } else {
                    TextField("Find in directory", text: $search_term)
                        .padding()
                        .background(.ultraThickMaterial)
                        .formStyle(.automatic)
                        .fontWeight(.semibold)
                        .font(.title)
                    HStack{
                        Button {
                            withAnimation(.bouncy) {
                                show_all = true
                            }
                        } label: {
                            Text("Show all")
                        }
                        Spacer()
                        Button {
                            withAnimation(.bouncy) {
                                if show_employees {
                                    show_employees = false
                                    show_all = true
                                } else {
                                    show_all = false
                                    show_employees = true
                                }
                            }
                            
                        } label: {
                            Text("Toggle employees")
                        }
                        Spacer()
                        Button {
                            withAnimation(.bouncy) {
                                if show_students {
                                    show_students = false
                                    show_all = true
                                } else {
                                    show_all = false
                                    show_students = true
                                }
                            }
                            
                        } label: {
                            Text("Toggle students")
                        }
                        
                    }.padding()
                    
                    ScrollView{
                        LazyVStack(pinnedViews: .sectionHeaders){
                            if show_all || show_employees {
                                Section(header: SectionTitle(title:"Staff List")) {
                                    LazyVGrid(columns: getGridColumns(column: 2)) {
                                        ForEach(contacts.filter({ $0.kind.contains("employee") }).filter({ search_term.count > 2 ? $0.name.contains(search_term) || $0.email.contains("\(search_term)") : $0.name != "" }).sorted(by: { gc_a, gc_b in
                                            gc_a.name < gc_b.name
                                        }), id: \.id){
                                            contact in
                                            GoogleUserCard(
                                                contact: contact,
                                                id: "employee-\(contacts.sorted(by:{$0.name < $1.name}).firstIndex(where: {$0.id == contact.id}) ?? 0)")
                                            .padding()
                                            .border(.green.opacity(0.50), width: search_term.count > 2 ? 4.0 : 0)
                                            .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                                            .padding()
                                            .onTapGesture {
                                                contact_details = contact
                                                show_details = true
                                            }
                                        }
                                    }.id(0)
                                }
                            }
                            if show_all || show_students{
                                Section(header: SectionTitle(title:"Student List")){
                                    LazyVGrid(columns: getGridColumns(column: 2)) {
                                        ForEach(contacts.filter({$0.kind.contains("student")}).filter({ search_term.count > 2 ? $0.name.contains(search_term) || $0.email.contains("\(search_term)")  : $0.name != "" }).sorted(by: { gc_a, gc_b in
                                            gc_a.name < gc_b.name
                                        }), id: \.id){
                                            contact in
                                            GoogleUserCard(
                                                contact: contact,
                                                id: "student-\(contacts.sorted(by:{$0.name < $1.name}).firstIndex(where: {$0.id == contact.id}) ?? 99999)")
                                            .padding()
                                            .border(.green.opacity(0.50), width: search_term.count > 2 ? 4.0 : 0)
                                            .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                                            .padding()
                                        }
                                    }.id("us-1")
                                }
                            }
                        }
                        
                        .onChange(of: search_term) { oldValue, newValue in
                            if newValue.count > 2 {
                                withAnimation(.bouncy) {
                                    scroller.scrollTo(0)
                                }
                            }
                        }
                        
                    }
                }
            }
            .sheet(isPresented: $show_details) {
                GeometryReader{ geo in
                    VStack{
                        Text(contact_details.name)
                            .font(.title)
                            .fontWeight(.heavy)
                        Divider()
                        if contact_details.photo != "tree" {
                            AsyncImage(url: URL(string: contact_details.photo ?? "")){
                                img in
                                img.image?.resizable()
                                    .frame(width: geo.size.width / 2, height: geo.size.height / 2, alignment: .center)
                            }
                        } else {
                            Image(contact_details.photo!)
                                .resizable()
                                .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                        }
                        VStack{
                            HStack{
                                VStack{
                                    Image(systemName: "person.circle")
                                        .font(.largeTitle)
                                    Text("Title:").font(.caption).fontWeight(.semibold)
                                    Text(contact_details.title.count > 1 ? contact_details.title : contact_details.kind == "employee" ? "Staff Member" : "Student")
                                }
                                Spacer()
                                VStack{
                                    Image(systemName: "envelope")
                                        .font(.largeTitle)
                                    Text("Email:").font(.caption).fontWeight(.semibold)
                                    Text(contact_details.email)
                                }
                            }
                            .padding()
                            HStack{
                                VStack{
                                    Image(systemName: "building")
                                        .font(.largeTitle)
                                    Text("Department:").font(.caption).fontWeight(.semibold)
                                    Text(contact_details.department ?? contact_details.kind == "employee" ? "Student" : "Staff")
                                }
                                Spacer()
                                VStack{
                                    Image(systemName: "door.left.hand.closed")
                                        .font(.largeTitle)
                                    Text("Room:").font(.caption).fontWeight(.semibold)
                                    Text(contact_details.room ?? "198")
                                }
                                Spacer()
                                VStack{
                                    Image(systemName: "phone.fill")
                                        .font(.largeTitle)
                                    Text(contact_details.kind == "employee" ? "Extension:" : "Student ID:").font(.caption).fontWeight(.semibold)
                                    Text(contact_details.kind == "employee" ? contact_details.phone ?? "100" : contact_details.id)
                                }
                            }
                        }
                        .padding()
                    }.foregroundStyle(Color("PrimaryColor"))
                }
            }
        }
    }
    private func getContacts(){
        
        let url = "https://admin.googleapis.com/admin/directory/v1/users?domain=thewcs.org&projection=full&query=isSuspended%3Dfalse&sortOrder=ASCENDING"
        
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
                let presentingm = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
                if let json_object = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    
                    if let google_users = json_object["users"] as? [[String:Any]] {
                        let next_page_token = json_object["nextPageToken"]
                        for google_user in google_users {
                            let names = google_user["name"] as? [String:Any]
                            let google_user_name = names?["fullName"]
                            let google_user_photo_etag = google_user["thumbnailPhotoEtag"] as? String
                            
                            _ = google_user["suspended"] as? Int
                            
                            let google_user_org_path = google_user["orgUnitPath"] as? String
                            
                            _ = google_user["id"] as? String
                            
                            let google_user_orgs = google_user["organizations"] as? [[String:Any]]
                            let google_user_department = google_user_orgs?.first?["department"]
                            let google_user_title = google_user_orgs?.first?["title"]
                            
                            let google_user_is_admin = google_user["isAdmin"] as! Bool
                            let google_user_thumbnail = google_user["thumbnailPhotoUrl"] as? String ?? google_user_photo_etag
                            
                            let google_user_primary_email = google_user["primaryEmail"] as? String ?? ""
                            
                            let google_user_kind = getKind(email: google_user_primary_email)
                            
                            func getKind(email:String) -> String {
                                
                                if ((email.split(separator: "")[2].first!.isNumber)){
                                    return "student"
                                }
                                return "employee"
                            }
                            
                            let new_google_contact = GoogleContact(
                                name: google_user_name as? String ?? "",
                                photo: google_user_thumbnail ?? image_placeholder,
                                email: google_user_primary_email,
                                department: google_user_department as? String ?? google_user_org_path,
                                title: google_user_title as? String ?? "",
                                is_admin: google_user_is_admin,
                                phone: getExtension(email: google_user_primary_email).first,
                                room: getExtension(email: google_user_primary_email).last,
                                kind: google_user_kind
                            )
                            if new_google_contact.email == user_model.current_user.email {
                                user_model.current_user.is_admin = google_user_is_admin
                            }
                            contacts.append(new_google_contact)
                            
                        }
                        nextPage(token: next_page_token as! String)
                    }
                    
                    if json_object.keys.contains("error"){
                        
                        GIDSignIn.sharedInstance.currentUser?.addScopes(granted_scopes, presenting:presentingm!){
                            yn, error in
                            if let error = error {
                                print("EXERRR \(error.localizedDescription)")
                            }
                        }
                    }
                }
            } catch(let e) {
                print("Error doing \(e)")
            }
        }
        task.resume()
    }
    private func nextPage(token:String){
        
        
        let url = "https://admin.googleapis.com/admin/directory/v1/users?domain=thewcs.org&maxResults=500&pageToken=\(token)&projection=full&query=isSuspended%3Dfalse&sortOrder=ASCENDING"
        
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
                let presentingm = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
                if let json_object = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    
                    if let google_users = json_object["users"] as? [[String:Any]] {
                        let next_page_token = json_object["nextPageToken"]
                        for google_user in google_users {
                            let names = google_user["name"] as? [String:Any]
                            let google_user_name = names?["fullName"]
                            _ = google_user["thumbnailPhotoEtag"] as? String
                            
                            let user_suspended = google_user["suspended"] as? Int
                            
                            let google_user_org_path = google_user["orgUnitPath"] as? String
                            
                            _ = google_user["id"] as? String
                            
                            let google_user_orgs = google_user["organizations"] as? [[String:Any]]
                            let google_user_department = google_user_orgs?.first?["department"]
                            let google_user_title = google_user_orgs?.first?["title"]
                            
                            let google_user_is_admin = google_user["isAdmin"] as! Bool
                            let google_user_thumbnail = google_user["thumbnailPhotoUrl"] as? String ?? image_placeholder
                            
                            let google_user_primary_email = google_user["primaryEmail"] as! String
                            
                            let google_user_kind = getKind(email: google_user_primary_email)
                            
                            
                            func getKind(email:String) -> String {
                                
                                if ((email.split(separator: "")[2].first!.isNumber)){
                                    return "student"
                                }
                                return "employee"
                            }
                            
                            if (user_suspended != nil){
                                let new_google_contact = GoogleContact(
                                    name: google_user_name as? String ?? "",
                                    photo: google_user_thumbnail ,
                                    email: google_user_primary_email,
                                    department: google_user_department as? String ?? google_user_org_path,
                                    title: google_user_title as? String ?? "",
                                    is_admin: google_user_is_admin,
                                    phone: getExtension(email: google_user_primary_email).first,
                                    room: getExtension(email: google_user_primary_email).last,
                                    kind: google_user_kind
                                )
                                contacts.append(new_google_contact)
                                let count = contacts.count
                                if count % 500 == 0 {
                                    if next_page_token != nil {
                                        nextPage(token: next_page_token as! String)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    
                    if json_object.keys.contains("error"){
                        
                        GIDSignIn.sharedInstance.currentUser?.addScopes(granted_scopes, presenting:presentingm!){
                            yn, error in
                            if let error = error {
                                print("EXERRR \(error.localizedDescription)")
                            }
                        }
                    }
                }
            } catch(let e) {
                print("Error doing \(e)")
            }
        }
        task.resume()
    }
    
    
    func getExtension(email:String) -> [String] {
        if user_ext.contains(where: {$0.email == email}) {
            let u_ext = user_ext.first(where: {$0.email == email})
            let google_user_room = u_ext?.room ?? "198"
            let google_user_ext = u_ext?.ext ?? "100"
            
            return [google_user_ext, google_user_room]
        }
        return ["", ""]
    }
    }


#Preview {
    ContactsView()
}
