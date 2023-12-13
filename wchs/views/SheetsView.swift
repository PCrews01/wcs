//
//  SheetsView.swift
//  wchs
//
//  Created by Paul Crews on 11/6/23.
//

import SwiftUI

struct SheetsView: View {
    @EnvironmentObject var user_model : UserModel
    @State var sheets : [GWForm] = []
    var body: some View {
        PageHeader(title: "Sheets")
        if sheets.count < 1 {
            Text("Helpdesk")
                .onAppear {
                    getSheets()
                }
        } else {
            List{
                ForEach(sheets, id:\.id){ form in
                    Link(destination: URL(string: "https://docs.google.com/\(form.mime_type.split(separator: ".").last ?? "spreadsheets")s/d/\(form.id)/")!) {
                        HStack{
                            Text(form.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(form.mime_type)
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color("PrimaryColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    private func getSheets(){
        
        let url = "https://www.googleapis.com/drive/v3/files?corpus=user&q=mimeType%3D%22application%2Fvnd.google-apps.spreadsheet%22"
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
                    let returned_files = json_object.filter({$0.key == "files"})
                    
                    for file in returned_files{
                            if let c = file.value as? [[String:String]]{
                                for x in c {
                                    let new_file : GWForm = GWForm(id: x["id"] ?? "No ID", kind: x["kind"] ?? "No Kind", mime_type: x["mimeType"] ?? "No Mime", name: x["name"] ?? "No Name", sheet_id: "")
                                    withAnimation(.bouncy){
                                        sheets.append(new_file)
                                    }
                                }
                            
                        }
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
    SheetsView()
}
