//
//  data.swift
//  wchs
//
//  Created by Paul Crews on 11/4/23.
//

import Foundation
import SwiftUI

struct UserScope{
    var id = UUID().uuidString
    var title : String
    var view : any View
    var need_admin : Bool
}
extension UserScope:Identifiable{}
extension UserScope:Hashable{
    static func == (lhs: UserScope, rhs: UserScope) -> Bool {
        let result = lhs.id.compare(rhs.id) == .orderedSame
        return result
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

let scopes : [UserScope] = [
    UserScope(title: "Home", view: ContentView(), need_admin: false),
    UserScope(title: "Forms", view: ContentView(), need_admin: false),
    UserScope(title: "Sheets", view: ContentView(), need_admin: false),
    UserScope(title: "Docs", view: ContentView(), need_admin: false),
    UserScope(title: "Drive", view: ContentView(), need_admin: false),
    UserScope(title: "Contacts", view: ContentView(), need_admin: false),
    UserScope(title: "Helpdesk", view: HelpdeskView(), need_admin: true),
    UserScope(title: "Admin", view: AdminView(), need_admin: true),
//    UserScope(title: "Weather", view: WeatherPit(), need_admin: false)
]
let granted_scopes : [String] = [
    "https://www.googleapis.com/auth/directory.readonly",
    "https://www.googleapis.com/auth/contacts.readonly",
    "https://www.googleapis.com/auth/contacts.other.readonly",
    "https://www.googleapis.com/auth/contacts",
    "https://www.googleapis.com/auth/drive",
    "https://www.googleapis.com/auth/drive.file",
    "https://www.googleapis.com/auth/spreadsheets"
]
let school_devices = ["Chromebooks", "Surfaces", "Macbooks", "iMacs", "iPads", "Printers", "Projectors", "Phones", "HotSpots"]
let image_placeholder = "tree"

let default_contact : GoogleContact = GoogleContact(name: "", email: "", title: "", is_admin: false, kind: "Default")

let user_ext : [UserExtension] = [
    UserExtension(ext: "101", room:"621", name:"Alejandra Aburdene", email:"aaburdene@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "132", room:"321", name:"Kristen Assenzio", email:"kassenzio@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "102", room:"415", name:"Jahi Bashir", email:"jbashir@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "104", room:"M017", name:"Brooke Bolnick", email:"bbolnick@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "149", room:"611", name:"Matthew Carenza", email:"mcarenza@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "128", room:"411", name:"Lawrence Combs", email:"lcombs@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "105", room:"123", name:"Earline Cooper", email:"ecooper@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "140", room:"122", name:"Courtesy Phone", email:"cphone@thewcs.org", phone:"718-782-9830"),
    UserExtension(ext: "126", room:"815", name:"Paul Crews", email:"pcrews@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "100", room:"Main Desk", name:"Ivette Cruz", email:"icruz@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "108", room:"M004", name:"Renee De Lyon", email:"rdelyon@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "111", room:"827", name:"Kathy Fernandez", email:"kfernandez@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "148", room:"822", name:"Arturo Giscombe", email:"agiscombe@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "129", room:"721", name:"Brittany Gozikowski", email:"bgozikowski@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "114", room:"717", name:"Rodney Guzman Cruz", email:"rguzmancruz@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "107", room:"8FL Desk", name:"Anesa Hanif", email:"ahanif@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "115", room:"209", name:"Angie Helliger", email:"ahelliger@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "150", room:"823", name:"Janelle Holford", email:"jholford@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "150", room:"823", name:"Janelle Holford", email:"jholford@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "117", room:"504", name:"Valerie Jacobson", email:"vjacobson@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "118", room:"820", name:"Raymond James", email:"rjames@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "119", room:"421", name:"Charisse Johnson", email:"cjohnson@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "120", room:"821", name:"Tamisha Johnson", email:"tjohnson@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "103", room:"M005", name:"Kelly Leprohon", email:"kLeprohon@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "134", room:"M008", name:"Abeje Leslie-Smith", email:"aleslie@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "141", room:"121", name:"Library", email:"library", phone: "718-782-9830"),
    UserExtension(ext: "122", room:"826", name:"Belnardina Madera", email:"bmadera@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "123", room:"Remote", name:"Katie Manion", email:"kmanion@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "125", room:"711", name:"Shante Martin", email:"smartin@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "127", room:"124", name:"Mariella Medina", email:"mmedina@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "143", room:"126", name:"Nurse", email:"nurse@thewcs.org", phone:"718-782-9830"),
    UserExtension(ext: "243", room:"831", name:"Geraldine Offei", email:"goffei@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "106", room:"812", name:"Melody Pink", email:"mpink@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "131", room:"717", name:"Tiffany Pratt", email:"tpratt@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "132", room:"7th Fl", name:"Natasha Robinson", email:"nrobinson@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "142", room:"Lobby", name:"Safety Desk", email:"", phone:"718-782-9830"),
    UserExtension(ext: "151", room:"M003", name:"Samantha Sales", email:"ssales@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "144", room:"102B", name:"School Foods", email:"", phone:"718-782-9830"),
    UserExtension(ext: "133", room:"M006", name:"Chered Spann", email:"cspann@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "113", room:"531", name:"Elodie St. Fleur", email:"estfleur@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "145", room:"214", name:"Teacher's Lounge 1", email:"", phone:"718-782-9830"),
    UserExtension(ext: "146", room:"214", name:"Teacher's Lounge 2", email:"", phone:"718-782-9830"),
    UserExtension(ext: "147", room:"214", name:"Teacher's Lounge 3", email:"", phone:"718-782-9830"),
    UserExtension(ext: "112", room:"822", name:"Justin Usher", email:"jusher@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "136", room:"122", name:"Allison Witkowski", email:"awitkowski@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "137", room:"505", name:"Rosa Yenque", email:"ryenque@thewcs.org", phone: "718-782-9830"),
    UserExtension(ext: "138", room:"127", name:"Silvia Yenque", email:"syenque@thewcs.org", phone: "718-782-983"),

    ]


var dummy_employee_form : EmployeeForm = EmployeeForm(first_name: "", last_name: "", department: "", title: "", phone: "")

var dummy_student_form : StudentForm = StudentForm(id: "", first_name: "",last_name: "")

var dummy_chromebook_form : ChromebookForm = ChromebookForm(email: "", issue: "", old_serial: "", new_serial: "")

var dummy_helpdesk_form : HelpdeskForm = HelpdeskForm(email: "", subject: "", issue: "", impact: "*")

var dummy_purchase_form : PurchaseForm = PurchaseForm(vendor: "", item: "", quantity: 0, description: "", price: "0.00")

var dummy_password_form : PasswordForm = PasswordForm(id: "*", email: "")

var sheet_alphabet : [String] = [
"a","b","d","e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

func getGridColumns(column:Int) -> [GridItem]{
    var columns : [GridItem] = []
    for _ in 1...column{
        columns.append(GridItem(.flexible()))
    }
    return columns
}


func getInventoryCell(device:String) -> String {
    if device.count > 0 {
        if device.contains("Chromebook"){
            return "H2"
        } else if device.contains("Surface"){
            return "N2"
        } else if device.lowercased().contains("macbook"){
            return "L2"
        } else if device.lowercased().contains("imac"){
            return "W2"
        } else if device.lowercased().contains("m2"){
            return "K2"
        } else if device.lowercased().contains("ipad"){
            return "M2"
        }else if device.lowercased().contains("phones"){
            return "Q2"
        }else if device.lowercased().contains("hotspot"){
            return "R2"
        }else if device.lowercased().contains("projector"){
            return "P2"
        }else if device.lowercased().contains("printer"){
            return "O2"
        }
    }
    return ""
}
func getInventorySheet(device:String)->String{
    
    if device.count > 0 {
        if device.contains("Chromebook"){
            return "Chromebooks!A1:D"
        } else if device.contains("Surface"){
            return "Surfaces!A1:F"
        } else if device.lowercased().contains("macbook"){
            return "Macbooks!A1:G"
        } else if device.lowercased().contains("loaner"){
            return "Loaners!A1:D"
        } else if device.lowercased().contains("desktop"){
            return "Desktops!A1:D"
        } else if device.lowercased().contains("ipad"){
            return "iPads!A1:E"
        }else if device.lowercased().contains("phones"){
            return "Phones!A1:E"
        }else if device.lowercased().contains("hotspot"){
            return "Hotspots!A1:C"
        }else if device.lowercased().contains("projector"){
            return "Projectors!A1:G"
        }else if device.lowercased().contains("printer"){
            return "Printers!A1:F"
        }else if device.lowercased().contains("imac"){
            return "iMacs!A1:F"
        }
    }
    return ""
}

//// CHANGE SHEET TO NEW HEADERS
