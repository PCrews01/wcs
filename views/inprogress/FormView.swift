//
//  FormView.swift
//  wchs
//
//  Created by Paul Crews on 12/7/23.
//

//// To get form field use the id from the form editing
///Use the form response spreadsheet to get the form fields?

import SwiftUI
import OpenAIKit
import ChatGPTSwift

struct FormView: View {
    @EnvironmentObject var user_model   :   UserModel
    @State var status_message           :   String              =   ""
    @State var form_headers             :   [String]            =   []
    @State var form_title               :   String              
    @State var form_entry_paragraph     :   String              =   ""
    @State var form_entry_toggle        :   Bool                =   true
    @State var form_responses           :   [String:String]     =   [:]
    @State var checked_questions        :   [String]            =   []
    @State var is_included_in_response  :   [String]            =   []
    @State var sheet_id                 :   String
    
    var body: some View {

        PageHeader(title: "\(form_title) form")
        if form_headers.isEmpty {
            VStack{
                if status_message.isEmpty{
                    ProgressView {
                        Text(sheet_id)
                    }
                }else{
                    Text(status_message)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                }
            }
            .onAppear {
                getFormInfo(sheet_id: sheet_id)
            }
        } else {
            VStack{
                HStack{
                    Spacer()
                    Toggle("", isOn: $form_entry_toggle)
                        .frame(width: 150)
                        .animation(.bouncy, value: form_entry_toggle)
                    Image(systemName: form_entry_toggle ? "pencil.line" : "quote.closing")
                }
                ScrollView{
                    if !form_entry_toggle {
                        Text("Form entry")
                        
                        ScrollView{
                            ForEach(form_responses.sorted(by: {$0.0 < $1.0}), id:\.key) {
                                key, val in
                                TextField(text: .constant(val)) {
                                    Text(key)
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .frame(width: 500)
                            }
                        }
                    } else {
                        VStack{
                            Text("Summary entry")
                            Text("Summarize the event. Be sure to answer the form questions in your paragraph.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            TextField(form_title, text: $form_entry_paragraph, axis: .vertical)
                                .multilineTextAlignment(.leading)
                                .lineLimit(form_headers.count * 2)
                                .padding()
                                .background(.ultraThinMaterial)
                                .ignoresSafeArea(.keyboard)
                            
                            VStack{
                                //                        loop through the headers to call key in form responses.
                                ForEach(form_headers, id:\.self){
                                    fheader in
                                    if form_responses[fheader.replacingOccurrences(of: "_", with: " ")] != "" {
                                        let res_val = form_responses[fheader.replacingOccurrences(of: "_", with: "_")] ?? ""
                                        HStack{
                                            Image(systemName: res_val != "N/A" ? "check" : "cross")
                                            Text("\(fheader)")
                                            Spacer()
                                            Text("\(res_val)")
                                        }
                                        .foregroundStyle(res_val != "N/A" ? .green : .red)
                                        .frame(width: 500)
                                        .onAppear {
                                            checkFields()
                                        }
                                        
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                Button(action: {
                    if form_entry_paragraph.contains(" ") && form_entry_paragraph.count > 10{
                        checkFormEntry(entry: form_entry_paragraph)
                    }
                }, label: {
                    Text("Submit")
                })
            }.padding()
        }
    }
    
    func checkFields(){
        for response in form_responses {
//            print("+++++Response \(response)")
        }
    }
    
    func getFormInfo(url:String="", sheet_id:String, token:String="", user:GoogleDomainUser=d_user, range:String=""){
            //        print("Runner")
            //// Set the url of the form we want to use
            guard let get_url = URL(string: "https://forms.googleapis.com/v1/forms/\(sheet_id)") else {
                print("invalid url")
                return
            }
            
            //// Using the url we created above create a URL Request variable
            var form_request = URLRequest(url: get_url)
            
            //// Set the request method
            form_request.httpMethod = "GET"
            
            //// Set the authorization header using the access token of the logged in user
            form_request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
            /// Set the content type header and the accept header to application/json so that the form is properly structured for the API call
            form_request.addValue("application/json", forHTTPHeaderField: "Accept")
            form_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            /// Create a new URL Session to get data from API
            let form_request_session = URLSession.shared.dataTask(with: form_request){
                (data, response, error) in
                
                /// check for errors in call
                if let error = error {
                    print("There was an error with the form \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    print("No data returned from call")
                    return
                }
                
                do {
                    if let json_returned_data = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        //                    print("Json returned \(json_returned_data)")
                        if let values = json_returned_data["linkedSheetId"] as? String{
                            getFormHeaders(form_id: values)
                            //                        print("Values \(values)")
                        }
                    }
                } catch(let error){
                    
                    print("There was an error serializing the data \(error.localizedDescription)")
                    return
                }
            }
                .resume()
        }
        
    func getFormHeaders(form_id:String){
        let fome = "FormResponses1!A1:Z"
        let sheet_update_url = "https://sheets.googleapis.com/v4/spreadsheets/\(form_id)"
        let updater = "\(sheet_update_url)/values/\(fome):append?valueInputOption=USER_ENTERED"
        //        print("SHeer update \(sheet_update_url)")
        guard let get_url = URL(string: sheet_update_url) else {
            print("invalid url")
            return
        }
        var form_request = URLRequest(url: get_url)
        
        //// Set the request method
        form_request.httpMethod = "GET"
        
        //// Set the authorization header using the access token of the logged in user
        form_request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
        /// Set the content type header and the accept header to application/json so that the form is properly structured for the API call
        form_request.addValue("application/json", forHTTPHeaderField: "Accept")
        form_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: form_request){
            (data, response, error) in
            
            /// check for errors in call
            if let error = error {
                print("There was an error with the form \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data returned from call")
                return
            }
            
            do {
                if let json_returned_data = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    if let values = json_returned_data["sheets"] as? [[String:Any]]{
                        if let properties = values.first!["properties"] as? [String:Any] {
                            let sheet_type = properties["sheetType"] as? String
                            if sheet_type == "GRID"{
                                let grid_properties = properties["gridProperties"] as! [String:Any]
//                                                                print("Show title \(json_returned_data)")
                                let new_sheet : GoogleSpreadsheet = GoogleSpreadsheet(id: "\(json_returned_data["spreadsheetId"] ?? "0")" ,
                                                                                        title: "\(properties["title"] ?? "No Title")",
                                                                                        index: properties["index"] as! Int,
                                                                                        sheet_Type: properties["sheetType"] as! String,
                                                                                        column_count: grid_properties["columnCount"] as! Int,
                                                                                        row_count: grid_properties["rowCount"] as! Int)
                                
                                if new_sheet.id != "00"{
//                                    print("Ms \(new_sheet)")
                                    form_title = new_sheet.title
                                    getFormResponses(sheet: new_sheet)
                                }
                                
                            }
                        } else {
                            print("Values b no props")
                        }
                    } else {
//                        print("no vals")
                        let sheet_error = json_returned_data["error"]
//                            print("sheet \(sheet_error)")
//                                status_message = sheet_error
                        if let sheet_status = sheet_error as? [String:Any]{
//                            print("Sheet status \(sheet_status)")
                            status_message = "There's been an error:\n\(sheet_status["status"] as! String)"
                        } else {
                            print("No errors back \(json_returned_data["error"])")
                        }
                    }
                } else {
//                    print("Later")
                }
            } catch(let error){
                
                print("There was an error serializing the data \(error.localizedDescription)")
                return
            }
        }
        .resume()
    }
    
    func getAlphabet(count:Int) -> String{
    let alphabet = sheet_alphabet
    var sheet_letter = ""
    if count > alphabet.count {
        sheet_letter = alphabet[count / 26] + alphabet[count - 26]
    }
//    print(" Returned letter: \(sheet_letter)")
    return sheet_letter
}
    
    func getFormResponses(sheet:GoogleSpreadsheet){
            //        print(" Sheet som \(sheet.title)")
            let tetitl = "\(sheet.title)"
            let encodedTitle = tetitl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: " 000", with: "%27") ?? ""
            
            guard let sheet_url = URL(string:"https://sheets.googleapis.com/v4/spreadsheets/\(sheet.id)/values/%27\(encodedTitle)%27!A1:\(getAlphabet(count: sheet.column_count).capitalized)1") else {
                return
            }
//                    print("Sheet url \(sheet_url)")
            var request = URLRequest(url: sheet_url)
            request.addValue("Bearer \(user_model.current_user.access_token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let request_session = URLSession.shared.dataTask(with: request){
                (data, response, error) in
                if let error = error {
                    print("Error starting session: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    print("No data returned")
                    return
                }
                
                do{
                    if let json_output = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        guard let headers = json_output["values"] as? [[String]] else {
//                            print("Got response data \(json_output)")
                            return
                        }
                        //                    print("Headers \(headers)")
                        for header in headers[0].dropFirst() {
                            //                        print("Header \(header)")
                            withAnimation(.bouncy){
                                if !form_headers.contains(header){
                                    form_headers.append(header)
                                    let new_i = [header.replacingOccurrences(of: " ", with: "_") : ""]
                                    form_responses[header] = ""
                                    
                                }
                            }
//                            print("Responses \(form_responses)")
                        }
                    } else {
                        print("No response data \(response)")
                    }
                    
                } catch (let e){
                    print("Error doing json")
                    return
                }
            }
            request_session.resume()
            
        }
        
    func checkFormEntry(entry:String) {
        let api = ChatGPTAPI(apiKey: gpt_key)
        
        Task {
            do {
                let stream = try await api.sendMessage(text: "Check this paragraph \(form_entry_paragraph) to see if you can find answers to any of these  \(form_headers.joined(separator: ",")). Respond with a swiftui dictionary format; using formatted response")
                var ai_response = stream
                var new_dict = [String:String]()
                let key_vals = ai_response.components(separatedBy: "\n")
                
                for segment in key_vals {
                    let separator = segment.components(separatedBy: ":")
                    if separator.count == 2 {
                        let key = separator[0].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "_", with: " ")
                        let val = separator[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
                        new_dict[key] = val
                        withAnimation(.bouncy){
                            //                            if !form_responses.keys.contains(key){
                            form_responses.updateValue(val, forKey: key)
                            //                            }
                        }
                    }
                    print(" Form res \(form_responses)")
                }
                guard !new_dict.isEmpty else { return }
                
                do {
                    let json_object = try JSONSerialization.data(withJSONObject: new_dict)
                    guard let json_dict = try JSONSerialization.jsonObject(with: json_object, options: []) as? [String:String] else {
                        return
                    }
                    
                } catch (let e){
                    print("Error doring 296 \(e.localizedDescription)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

func getForms(form:String){
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
 }
 
 func runMirror(form_type: Mirror){
     for (property,_) in form_type.children {
         if let form_property = property{
             withAnimation(.bouncy){
                     let selected_form : FormEntry = FormEntry(title: form_property.replacingOccurrences(of: "_", with: ""), value: "")
//                     form_fields.append(selected_form)
             }
         }
     }
}
}
