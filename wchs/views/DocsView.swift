//
//  DocsView.swift
//  wchs
//
//  Created by Paul Crews on 11/6/23.
//

import SwiftUI

struct DocsView: View {
    @EnvironmentObject var user_model : UserModel
    @State var docs : [GWForm]  = []
    
    var body: some View {
        PageHeader(title: "Docs")
        if docs.count < 1 {
            Text("Docs")
                .onAppear {
                    getDocs()
                }
        } else {
            List{
                ForEach(docs, id:\.id){ doc in
                    Link(destination: URL(string: "https://docs.google.com/\(doc.mime_type.split(separator: ".").last ?? "document")/d/\(doc.id)/")!) {
                    HStack{
                        Text(doc.name)
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
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
    
    
    private func getDocs(){
        
        let url = "https://www.googleapis.com/drive/v3/files?corpus=user&q=mimeType%3D%22application%2Fvnd.google-apps.document%22"
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
                                    docs.append(new_file)
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
    
    func getDocByID(id:String){
//        print("IF \(id)")
        let url = "https://docs.googleapis.com/v1/documents/\(id)"
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
                    if let body = json_object["body"] as? [String: Any]{
                        if let content = body["content"] as? [[String:Any]]{
//                            print("El \(content)")
                            for i in content {
                                if i.contains(where: { (key: String, value: Any) in
                                    key == "paragraph"
                                }){
                                    if let paragraph = i["paragraph"] as? [String:Any]{
                                        
                                        if let elements = paragraph["elements"] as? [[String:Any]]{
                                            for j in elements{
                                               if let text_run = j["textRun"] as? [String:Any]{
                                                   if let content = text_run["content"] as? String {
//                                                       print("II EL \(content)")
                                                       
                                                   }
                                                }
                                            }
                                        } else {
                                            print("No elements \(paragraph)")
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        print("this Doc is \(json_object)")
                    }
                    let returned_files = json_object.filter({$0.key == "files"})
                    
                    for file in returned_files{
//                        print("Thisis file \(file)")
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
    DocsView()
}
