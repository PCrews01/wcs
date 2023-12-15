//
//  DriveView.swift
//  wchs
//
//  Created by Paul Crews on 11/4/23.
//

import SwiftUI

struct DriveView: View {
    @EnvironmentObject var user_model : UserModel
    @State var drive_files : [GoogleFile] = []
    @State var sort : String = ""
    var body: some View {
        PageHeader(title: "Drive Files")
        HStack{
            Button{
                withAnimation(.bouncy){
                    sort = "mime"
                }
            } label:{
                Text("Sort by kind")
            }
            Spacer()
            Button{
                withAnimation(.bouncy){
                    sort = "name"
                }
            } label:{
                Text("Sort by name")
            }
        }.padding(.horizontal)
        if drive_files.count < 1{
            VStack{
                ProgressView()
                Text("Loading files")
                    .onAppear() {
                        getDriveFiles()
                    }
            }
        } else {
            List{
                ForEach(drive_files.sorted(by: sort == "mime" ? {$0.mime_type < $1.mime_type} : sort == "name" ? {$0.name < $1.name} : {$0.id < $1.id}), id:\.id){
                    file in
                    Link(destination: URL(string: "https://docs.google.com/\(file.mime_type.split(separator: ".").last ?? "spreadsheets")/d/\(file.id)/")!) {
                        HStack{
                            Text(file.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(file.mime_type)
                        }
                        .padding()
                        .background(getBackgroundColor(mime: file.mime_type))
                        .foregroundStyle(getBackgroundColor(mime: file.mime_type) == .white ? .black : .white)
                    }
                }
            }
        }
    }
    private func getBackgroundColor(mime: String) -> Color{
        
        if mime.contains("spreadsheet"){
            return .green
        } else if mime.contains("document"){
            return .blue
        } else if mime.contains("text/plain"){
            return .gray
        } else if mime.contains("pdf"){
            return .red
        } else if mime.contains("presentation"){
            return .orange
        }
        
        return .white
            
    }
    private func getDriveFiles(){
        let url = "https://www.googleapis.com/drive/v3/files"
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
                    for file in json_object.values{
                        var new_file = GoogleFile(id: "", kind: "", mime_type: "", name: "")
                        if "\(type(of: file))" == "__NSArrayI"{
                            let filer = file as! [[String:String]]
                            for filer_file in filer {
                                new_file.id = filer_file["id"] ?? "No ID"
                                new_file.kind = filer_file["kind"] ?? "No Kind"
                                new_file.mime_type = filer_file["mimeType"] ?? "No Mime Type"
                                new_file.name = filer_file["name"] ?? "No Name"
                                
                                withAnimation(.bouncy){
                                    drive_files.append(new_file)
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
    DriveView()
}
