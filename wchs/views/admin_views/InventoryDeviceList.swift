//
//  InventoryDeviceList.swift
//  wchs
//
//  Created by Paul Crews on 11/27/23.
//

import SwiftUI
import Charts

struct InventoryDeviceList: View {
    @EnvironmentObject var user_model : UserModel
    @State var device_to_list : String
    @State var inventory_list : [InventoryDevice] = []
    var body: some View {
        VStack{
            //            PageHeader(title: "\(device_to_list) List")
            if inventory_list.count == 0{
                ProgressView {
                    Text("Loading")
                        .onAppear{
                            getDeviceList()
                        }
                }
            } else {
                Table(of: InventoryDevice.self) {
                    TableColumn("\(retitle(title:"Vendor"))", value: \.vendor)
                    TableColumn("\(retitle(title:"Model"))", value: \.model)
                    TableColumn("\(retitle(title: "Serial"))", value: \.serial)
                    TableColumn("\(retitle(title:"Tag"))", value: \.tag)
                    TableColumn("\(retitle(title: "User"))", value: \.user)
                    TableColumn("\(retitle(title: "Status"))", value: \.status)
                    TableColumn("\(retitle(title: "Location"))", value: \.location)
                } rows: {
                    ForEach(inventory_list.dropFirst(), id:\.id){
                        devive in
                        TableRow(devive).contextMenu(menuItems: {
                            Text("\(retitle(title:"Vendor")): \(devive.vendor)")
                            Text("\(retitle(title: "Model")): \(devive.model)")
                            Text("\(retitle(title: "Serial")): \(devive.serial)")
                            Text("\(retitle(title: "User")): \(devive.user)")
                            Text("\(retitle(title: "Status")): \(devive.status)")
                            Text("\( retitle(title: "Location")): \(devive.location)")
                        })
                        
                    }
                    TableRow(InventoryDevice(vendor: "NO", model: "Mo", serial: "Se", tag: "Ta", user: "Us", status: "St", location: "lo"))
                }.frame(minHeight: UIDevice().orientation.isLandscape ? 200 : 700)
            }
        }.background(.red.opacity(0.4))
            .frame(minWidth: 800)
        Text("")
    }
    func getDeviceList(){
//        print("Device to list \(device_to_list.split(separator: " ").first)")
        let sheet_id = data_set_id
        let sheet_range = "\(device_to_list.split(separator: " ").first ?? "Chromebooks")s!A1:H"
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
                        
                        let device_vendor = values.first!.firstIndex(of: "Vendor") ?? 0
                        let device_model = values.first!.firstIndex(of: "Model") ?? 1
                        let device_serial = values.first!.firstIndex(of: "Serial") ?? 2
                        let device_tag = values.first!.firstIndex(of: "Tag") ?? 3
                        let device_user = values.first!.firstIndex(of: "User") ?? 4
                        let device_status = values.first!.firstIndex(of: "Status") ?? 5
                        let device_location = values.first!.firstIndex(of: "Location") ?? values.count - 1
                        let device_other = values.first!.firstIndex(of: "Other")
//                        values.first!.firstIndex(of: "Other")
                        
                        for value in values {
                            if let device_info = InventoryDevice(
                                vendor:     value[device_vendor],
                                model:      value[device_model],
                                serial:     value[device_serial],
                                tag:        value[device_tag],
                                user:       value[device_user],
                                status:     value[device_status],
                                location:   value[device_location],
                                other:      value[device_other ?? values.count - 1]
                            ) as? InventoryDevice {
                                if !inventory_list.contains(device_info){
//                                    print("Device s \(inventory_list)")
//                                    withAnimation(.bouncy){
                                        inventory_list.append(device_info)
//                                    }
                                }
                            } else {
                                print("Error forming device")
                                return
                            }
                        }
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
    func retitle(title:String) -> String{
        if device_to_list.contains("Department"){
            switch title {
            case "Vendor":
                return "Department"
            case "Model":
                return "Manager"
            case "Serial":
                return "Title"
            case "Tag":
                return "Email"
            case "Status":
                return "Ext"
            default:
                return title
            }
        } else if device_to_list.contains("Printer"){
            switch title {
            case "Status":
                return "IP"
            case "Tag":
                return "Location"
            case "Location":
                return "Room"
            default:
                return title
            }
        }
        return title
    }
}
