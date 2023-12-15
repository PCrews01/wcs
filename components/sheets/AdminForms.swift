//
//  AdminForms.swift
//  wchs
//
//  Created by Paul Crews on 11/11/23.
//

import SwiftUI

struct AdminForms: View {
    @EnvironmentObject var user_model : UserModel
    @State var form_fields            :   [FormEntry] = []
    @State var advanced_fields        :   [FormEntry] = []
    @State var new_data               :   [String]    = []
    @State var form_shade             :   Double
    @State var form_name              :   String
    @State var show_form              :   Bool = false
    @State var show_advanced          :   Bool = false
    @State var form_filter            :   String = ""
    @State var hardware_inventory     :   [String:Int] = [:]
    @State var wchs_departments       :   [String] = ["Select Department", "Operations", "Non-Instructional Staff", "Instructional Staff", "Coaches", "Security"]
    @State var default_department     :   String = "Select Department"
    @State var form_complete          :   Bool = false
    @State var updated_email          :   String = ""
    @State var status_message         :   String = ""
    
    var body: some View {
        ScrollView{
            VStack{
                PageHeader(title: form_name)
                    .onAppear{
                        getForm(form: form_name)
                    }
                Button {
                    getForm(form: form_name.lowercased())
                } label: {
                    
                    Text("")
                        .foregroundStyle(.black)
                        .onAppear{
                            if form_fields.count < 1{
                                getForm(form: form_name.lowercased())
                            }
                        }
                }
            }
            VStack{
                if form_shade == 1 {
                    if !form_complete {
                        ForEach($form_fields, id:\.title){
                            $form_field in
                            if !$form_field.wrappedValue.value.contains("Select") && !$form_field.wrappedValue.title.lowercased().contains("department"){
                                TextField(text: $form_field.projectedValue.value) {
                                    Text($form_field.wrappedValue.title.replacingOccurrences(of: "_", with: ""))
                                }
                                .fontWeight(.semibold)
                                .font(.headline)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            } else if !$form_field.wrappedValue.title.lowercased().contains("department"){
                                Picker("Department", selection: $default_department) {
                                    ForEach(wchs_departments, id:\.self){
                                        Text($0)
                                    }
                                }.pickerStyle(.menu)
                            }
                        }
                    } else {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                            .foregroundStyle(.green)
                        Text("\(status_message)")
                            .foregroundStyle(Color("PrimaryColor"))
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    if !form_complete {
                    VStack{
                            Button {
                                var done = false
                                for form_field in form_fields {
                                    if form_field.value.count > 0 {
                                        if form_field.value != "Select"{
                                            new_data.append(form_field.value)
                                            done = true
                                        }
                                    } else {
                                        done = false
                                    }
                                }
                                if done {
                                    Task{
                                        await swapDevice()
                                        withAnimation(.bouncy){
                                            form_complete = true
                                        }
                                    }
                                }
                            } label: {
                                Text("Submit \(form_name)")
                                    .foregroundStyle(.white)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .fontWidth(.expanded)
                            }
                        }
                    .padding()
                    .frame(width: 500)
                    .background(Color("PrimaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    }
                } else {
                    if form_name.lowercased().contains("list"){
                        InventoryDeviceList(device_to_list: form_name)
                    }
                    if form_name.lowercased().contains("hardware"){
                        LazyVGrid(columns: getGridColumns(column: 3)) {
                            ForEach(school_devices, id:\.self){
                                device in
                                NavigationLink {
                                    DeviceInventoryView(device:device)
                                } label: {
                                
                                VStack{
                                    if hardware_inventory[device] != nil {
                                        Text("\(hardware_inventory[device]!)")
                                            .font(.largeTitle)
                                            .fontWeight(.black)
                                        let i = "\(device.dropLast())"
                                        Text("\(i) devices")
                                    }
                                }
                                .padding()
                                .frame(width: 200, height: 200, alignment: .center)
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onAppear {
                                    if hardware_inventory[device] == nil {
                                        withAnimation(.bouncy){
                                            getInventory(device: device, sheet: "")
                                        }
                                    }
                                }
                                }
                            }
                        }
                    }

                }
        }
            .padding()
            .background(Color("PrimaryColor").opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }.onChange(of: form_fields.count > 3 ? form_fields[2].value : form_fields.first?.value) { oldValue, newValue in
            let first = form_fields[1].value.first ?? "-"
            let user_email = "\(first)\(form_fields[2].value)@thewcs.org"
            
            updated_email = user_email.replacingOccurrences(of:" ", with: "" )
    }
    }
    
    func addNewDomainUser(user:GoogleDomainUser){
        guard let post_url = URL(string: "https://admin.googleapis.com/admin/directory/v1/users") else {
            print("Invalid url")
            return
        }
        
        var request = URLRequest(url: post_url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json_encoder = JSONEncoder()
        do {
            let user_data = try json_encoder.encode(user)
            request.httpBody = user_data
        
        } catch(let err){
            print("Error \(err.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request){
            data, response, error in
            if let error = error {
                print("Error  \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let json_response = try? JSONSerialization.jsonObject(with: data, options: [])
//                        print("The response in \(json_response)")
                        let reson =  json_response as! [String:Any]
                        let creation = reson["creationTime"]
                        status_message = "Success!!!\n\(new_data[1])'s account has been created."
                       
                    new_data = []
                } catch(let errors){
                    print("There was an error adding domain user: \(errors.localizedDescription)")
                    status_message = "Error creating \(new_data[1])'s account. \(errors.localizedDescription)."
                }
            }
//            if let response = response {
//                print("resp: \(response)")
//            }
        }.resume()
    }
    
    func getInventory(device:String?, sheet:String?){
        let sheet_id = data_set_id
        let sheet_range = "Totals!\(getInventoryCell(device: device ?? "Chromebook"))"
        let sheet_update_url = "https://sheets.googleapis.com/v4/spreadsheets/\(sheet_id)/values/\(sheet_range)"
        guard let s_id = URL(string: sheet_update_url) else {
            return
        }
        
        var request = URLRequest(url: s_id)
        request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let request_session = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            if let error = error {
                print("There was an error getting Inventory \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data returned from inventory.")
                return
            }
            
            do{
                if let json_output = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    if let values = json_output["values"] as? [[String]]{
                        let value = Int(values.first!.first!)
                        hardware_inventory.updateValue(value!, forKey: device ?? "Device")
                    } else {
                        print("No values \(json_output["values"] ?? "")")
                    }
                } else {
                    print("No json_output.")
                }
                
            }catch(let err){
                print("There was an error doing \(err.localizedDescription)")
            }
        }
        request_session.resume()
    }
    
    func swapDevice() async {
        let fome = form_name.contains("New Student") || form_name.contains("New Employee")   ? "ActiveUsers!A2:AM" : "ChromebookSwap!A2:D"
        let sheet_id = data_set_id
//        let sheet_range = "ChromebookSwap!A2:D"
        let sheet_update_url = "https://sheets.googleapis.com/v4/spreadsheets/\(sheet_id)/values/\(fome):append?valueInputOption=USER_ENTERED"
        
        if form_name == "New Employee" {
            let new_email = updated_email
            let new_org = "/Staff/\(default_department)"
            let new_password = "W3lcome!"
            let new_recovery = "enroll@thewcs.org"
            let new_manager = "PCrews@thewcs.org"
            let new_title = new_data[3]
            let new_id = new_data[0]
            let new_ext = new_data[4]
            let new_department = default_department
            
            ///Based on headers from the dataset Google Sheet - "ActiveUsers" sheet.
            new_data[0] = new_data[1]
            new_data[1] = new_data[2]
            new_data[2] = new_email
            new_data[3] = new_password
            new_data[4] = ""
            new_data.append(new_org)
            new_data.append(new_email)
            new_data.append("")
            new_data.append("")
            new_data.append(new_recovery)
            new_data.append("")
            new_data.append("")
            new_data.append("")
            new_data.append("1 718 782-9830")
            new_data.append("")
            new_data.append("")
            new_data.append("198 Varet Street Brooklyn, Ny 11206")
            new_data.append("")
            new_data.append(new_id)
            new_data.append("Staff")
            new_data.append(new_title)
            new_data.append(new_manager)
            new_data.append(new_department)
            new_data.append("")
            
            let new_user : GoogleDomainUser = GoogleDomainUser(
                primary_email: new_email,
                name: GoogleDomainUserName(given_name: new_data[0], family_name: new_data[1]),
                suspended: false,
                password: new_password,
                change_password: true,
                ip_whitelisted: false,
                ims: GoogleDomainUserIms(type: "work", im_protocol: "gtalk", im: "email", primary: true),
                emails: GoogleDomainUserEmails(address: new_email, type: "work", custom_type: "gtalk", primary: false),
                addresses: GoogleDomainUserAddresses(type: "work",custom_type:"",street_address: "198 Varet St.", locality: "Brooklyn", region: "NY", postal_code: "11206"),
                external_ids: GoogleDomainUserExternalId(value:"\(new_email.replacingOccurrences(of: "@", with: ""))\(new_title)", type: "Employee", custom_type: "Employee"),
                organizations: GoogleDomainUserOrganizations(name:"Williamsburg Charter High School", title: new_title, primary:true, type:"work", department:new_department, cost_center: "WCHS", floor_section: new_department, description: "\(new_title) @ \(new_department)"),
                phones: GoogleDomainUserPhones(value: "+1 718 782 9830", type: "work"),
                org_unit_path: new_org,
                include_in_global_address_list: true)
            
            addNewDomainUser(user: new_user)
        } 
        else  if form_name == "New Student"{
            let new_email = "\(new_data[1].first!)\(new_data[2].first!)\(new_data[0])@thewcs.org"
            let new_org = "/Students/\(new_data[3])"
//            let new_org = "/Students/Test"
            let new_password = "W3lcome!"
            let new_recovery = "enroll@thewcs.org"
//            let new_manager = new_data.last!.contains("7") || new_data.last!.contains("6") ? "AHelliger@thewcs.org" : "SMartin@thewcs.org"
            let new_manager = "test4@thewcs.org"
            let cohort = new_data[3]
            let id = new_data[0]
            
            
            new_data[0] = new_data[1]
            new_data[1] = new_data[2]
            new_data[2] = new_email
            new_data[3] = new_password
            new_data.append("")
            new_data.append(new_org)
            new_data.append(new_email)
            new_data.append("")
            new_data.append("")
            new_data.append(new_recovery)
            new_data.append("")
            new_data.append("")
            new_data.append("")
            new_data.append("1 718 782-9830")
            new_data.append("")
            new_data.append("")
            new_data.append("198 Varet Street Brooklyn, Ny 11206")
            new_data.append("")
            new_data.append(id)
            new_data.append("Student")
            new_data.append("Student")
            new_data.append(new_manager)
            new_data.append("Students")
            new_data.append("")
            
            let new_user : GoogleDomainUser = GoogleDomainUser(
                primary_email: new_data[2],
                name: GoogleDomainUserName(given_name: new_data[0], family_name: new_data[1]),
                suspended: false,
                password: new_data[3],
                change_password: true,
                ip_whitelisted: false,
                ims: GoogleDomainUserIms(type: "school", im_protocol: "gtalk", im: "email", primary: true),
                emails: GoogleDomainUserEmails(address: new_data[2], type: "work", custom_type: "gtalk", primary: false),
                addresses: GoogleDomainUserAddresses(type: "work",custom_type:"",street_address: "198 Varet St.", locality: "Brooklyn", region: "NY", postal_code: "11206"),
                external_ids: GoogleDomainUserExternalId(value:"\(new_data[2].replacingOccurrences(of: "@thewcs.org", with: ""))\(new_data[0])", type: "Student", custom_type: "Student"),
                organizations: GoogleDomainUserOrganizations(name:"Williamsburg Charter High School", title: "Student", primary:true, type:"school", department:cohort, cost_center: "WCHS", floor_section: "198", description: "\(cohort) student"),
                phones: GoogleDomainUserPhones(value: "+1 718 782 9830", type: "school"),
                org_unit_path: new_org,
                include_in_global_address_list: true)
//            print("New user \(new_user)")
            addNewDomainUser(user: new_user)
        }
        guard let s_id = URL(string: sheet_update_url) else {
            return
        }
        
        var requst = URLRequest(url: s_id)
        requst.httpMethod = "POST"
        requst.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        requst.addValue("application/json", forHTTPHeaderField: "Accept")
        requst.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let request_body = ["values": [new_data]]
        
        let json_data = try? JSONSerialization.data(withJSONObject: request_body)
        requst.httpBody = json_data
        
       let tasker =  URLSession.shared.dataTask(with: requst){
            data, response, error in
            if let error = error {
                print("Error in url session \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do{
                    let json_response = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("Uhm \(json_response)")
                } catch (let err){
                    print("There's been an error in do \(err.localizedDescription)")
                }
            }
        }
            tasker.resume()
        
        if tasker.state == .completed{
            withAnimation(.bouncy){
                new_data = []
                
                for form_field in form_fields.enumerated() {
//                    print("Form \(form_field)")
//                    form_fields[form_field]
                }
//                print("New data empty")
//                form_complete = true
            }
        }
    
    }
       
    func getForm(form:String){
        let new_employee_form   :   EmployeeForm    =   dummy_employee_form
        let new_student_form    :   StudentForm     =   dummy_student_form
        let new_chromebook_form :   ChromebookForm  =   dummy_chromebook_form
        let new_helpdesk_form   :   HelpdeskForm    =   dummy_helpdesk_form
        let new_purchase_form   :   PurchaseForm    =   dummy_purchase_form
        let new_password_form   :   PasswordForm    =   dummy_password_form
        
        if form.contains("employee") {
            runMirror(form_type: Mirror(reflecting: new_employee_form))
        } else if form.contains("student"){
            runMirror(form_type: Mirror(reflecting: new_student_form))
        } else if form.contains("device" ){
            runMirror(form_type: Mirror(reflecting: new_chromebook_form))
        }  else if form.contains("helpdesk"){
            runMirror(form_type: Mirror(reflecting: new_helpdesk_form))
        } else if form.contains("purchase"){
            runMirror(form_type: Mirror(reflecting: new_purchase_form))
        } else if form.contains("password"){
            runMirror(form_type: Mirror(reflecting: new_password_form))
        } else {
            let non : FormEntry = FormEntry(title: "none", value: "Select")
            form_fields.append(non)
            show_form.toggle()
        }
        
        func runMirror(form_type: Mirror){
            for (property,_) in form_type.children {
                if let form_property = property{
                    withAnimation(.bouncy){
                        if form_property.contains("__"){
                            let selected_form : FormEntry = FormEntry(title: form_property.replacingOccurrences(of: "_", with: ""), value: "")
                            advanced_fields.append(selected_form)
                        } else {
                            let selected_form : FormEntry = FormEntry(title: form_property.replacingOccurrences(of: "_", with: ""), value: "")
                            form_fields.append(selected_form)
                        }
                    }
                }
            }
        }
    }
}
