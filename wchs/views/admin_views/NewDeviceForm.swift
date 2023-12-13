//
//  NewDeviceForm.swift
//  wchs
//
//  Created by Paul Crews on 11/18/23.
//

import SwiftUI

struct NewDeviceForm: View {
    @EnvironmentObject var user_model : UserModel
    @State var values : [String:Any] = [:]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    func getValues(){
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
                        print("Values \(body)")
                            for ext in body {
                                print("ext \(body)")
                                
                                withAnimation(.bouncy){
//                                    extensions.append(user_extension)
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
    NewDeviceForm()
}
