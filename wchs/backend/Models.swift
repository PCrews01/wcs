//
//  Models.swift
//  wchs
//
//  Created by Paul Crews on 11/4/23.
//

import Foundation
import SwiftUI

struct GWUser {
    var id = UUID().uuidString
    var user_id         :   String
    var scopes          :   [String]
    var access_token    :   String
    var refresh_token   :   String
    var id_token        :   String
    var email           :   String
    var name            :   String
    var given_name      :   String
    var family_name     :   String
    var has_image       :   Bool
    var img_dimensions  :   URL
    var is_signed_in    :   Bool
    var is_admin        :   Bool
    
    init(user_id: String, scopes: [String], access_token: String, refresh_token: String, id_token: String, email: String, name: String, given_name: String, family_name: String, has_image: Bool, img_dimensions: URL, is_signed_in: Bool, is_admin:Bool) {
        self.user_id = user_id
        self.scopes = scopes
        self.access_token = access_token
        self.refresh_token = refresh_token
        self.id_token = id_token
        self.email = email
        self.name = name
        self.given_name = given_name
        self.family_name = family_name
        self.has_image = has_image
        self.img_dimensions = img_dimensions
        self.is_signed_in = is_signed_in
        self.is_admin = is_admin
    }
}

struct GoogleFile {
    var id          :   String
    var kind        :   String
    var mime_type   :   String
    var name        :   String
    
    init(id: String, kind: String, mime_type: String, name: String) {
        self.id = id
        self.kind = kind
        self.mime_type = mime_type
        self.name = name
    }
}

struct GoogleContact{
    var id              =   UUID().uuidString
    var name            :   String
    var photo           :   String?
    var email           :   String
    var department      :   String?
    var title           :   String
    var is_admin        :   Bool
    var phone           :   String?
    var room            :   String?
    var kind            :   String
    
    init(id: String = UUID().uuidString, name: String, photo: String? = nil, email: String, department: String? = nil, title: String, is_admin: Bool, phone: String? = nil, room: String? = nil, kind: String) {
        self.id = id
        self.name = name
        self.photo = photo
        self.email = email
        self.department = department
        self.title = title
        self.is_admin = is_admin
        self.phone = phone
        self.room = room
        self.kind = kind
    }
    
}

struct UserExtension {
    var id      =   UUID().uuidString
    var ext     :   String
    var room    :   String
    var name    :   String
    var email   :   String
    var phone   :   String
    
    init(id: String = UUID().uuidString, ext: String, room: String, name: String, email: String, phone: String) {
        self.id = id
        self.ext = ext
        self.room = room
        self.name = name
        self.email = email
        self.phone = phone
    }
    
}
extension UserExtension : Identifiable {}
struct AteraTicket {
    
    var TicketID: Int
    var TicketTitle: String
    var TicketNumber: String
    var TicketPriority: String
    var TicketImpact: String
    var TicketStatus: String
    var TicketSource: String
    var TicketType: String
    var EndUserID: Int
    var EndUserEmail: String
    var EndUserFirstName: String
    var EndUserLastName: String
    var EndUserPhone: String
    var TicketResolvedDate: String
    var TicketCreatedDate: String
    var first_comment: String
    var last_end_user_comment: String
    var last_technician_comment : String?
    
    init(TicketID: Int, TicketTitle: String, TicketNumber: String, TicketPriority: String, TicketImpact: String, TicketStatus: String, TicketSource: String, TicketType: String, EndUserID: Int, EndUserEmail: String, EndUserFirstName: String, EndUserLastName: String, EndUserPhone: String, TicketResolvedDate: String, TicketCreatedDate: String, first_comment:String, last_end_user_comment: String, last_technician_comment: String) {
        self.TicketID = TicketID
        self.TicketTitle = TicketTitle
        self.TicketNumber = TicketNumber
        self.TicketPriority = TicketPriority
        self.TicketImpact = TicketImpact
        self.TicketStatus = TicketStatus
        self.TicketSource = TicketSource
        self.TicketType = TicketType
        self.EndUserID = EndUserID
        self.EndUserEmail = EndUserEmail
        self.EndUserFirstName = EndUserFirstName
        self.EndUserLastName = EndUserLastName
        self.EndUserPhone = EndUserPhone
        self.TicketResolvedDate = TicketResolvedDate
        self.TicketCreatedDate = TicketCreatedDate
        self.first_comment = first_comment
        self.last_end_user_comment = last_end_user_comment
        self.last_technician_comment = last_technician_comment
    }
}

struct GWForm{
    var id          :   String
    var kind        :   String
    var mime_type   :   String
    var name        :   String
    var sheet_id    :   String
    init(id: String, kind: String, mime_type: String, name: String, sheet_id: String) {
        self.id = id
        self.kind = kind
        self.mime_type = mime_type
        self.name = name
        self.sheet_id = sheet_id
    }
}
extension GWForm : Identifiable {}

struct NewsArticle{
    var id                  =   UUID().uuidString
    var title               :   String
    var image               :   String
    var article_images      :   [String]?
    var story               :   String
    var week               :   String
    
    init(id: String = UUID().uuidString, title: String, image: String, article_images: [String]? = [], story: String, week: String) {
        self.id = id
        self.title = title
        self.image = image
        self.article_images = article_images
        self.story = story
        self.week = week
    }
}

struct EmployeeForm {
    let id              =   UUID().uuidString
    var first_name      :   String
    var last_name       :   String
    var title           :   String
    var department      :   String?
    var phone           :   String?
    
    init(first_name: String, last_name: String, department: String? = nil, title: String, phone: String? = nil) {
        self.first_name = first_name
        self.last_name = last_name
        self.department = department
        self.title = title
        self.phone = phone
    }
}

struct StudentForm{
    var id          :   String
    var first_name  :   String
    var last_name   :   String
    var cohort      :   String?
    
    init(id: String, first_name: String, last_name: String, cohort: String? = nil) {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.cohort = cohort
    }
    
}

struct ChromebookForm{
    let id          =   UUID().uuidString
    var email       :   String
    var issue       :   String
    var old_serial  :   String
    var new_serial  :   String
    
    init(email: String, issue: String, old_serial: String, new_serial: String) {
        self.email = email
        self.issue = issue
        self.old_serial = old_serial
        self.new_serial = new_serial
    }
}

struct HelpdeskForm{
    let id          =   UUID().uuidString
    var email       :   String
    var subject     :   String
    var issue       :   String
    var impact      :   String?
    
    init(email: String, subject: String, issue: String, impact: String? = nil) {
        self.email = email
        self.subject = subject
        self.issue = issue
        self.impact = impact
    }
}

struct PurchaseForm{
    let id          =   UUID().uuidString
    var vendor      :   String
    var item        :   String
    var quantity    :   Int
    var link        :   String?
    var description :   String
    var price       :   String
    
    init(id: String = UUID().uuidString, vendor: String, item: String, quantity: Int, link: String? = nil, description: String, price: String) {
        self.vendor = vendor
        self.item = item
        self.quantity = quantity
        self.link = link
        self.description = description
        self.price = price
    }

}

struct PasswordForm{
    var id      =   UUID().uuidString
    var email   :   String
    
    init(id: String = UUID().uuidString, email: String) {
        self.id = id
        self.email = email
    }
}

struct FormTypes {
    var employee   :   EmployeeForm
    var student    :   StudentForm
    var chromebook :   ChromebookForm
    var helpdesk   :   HelpdeskForm
    var purchase   :   PurchaseForm
    var password   :   PasswordForm
    
    init(employee: EmployeeForm, student: StudentForm, chromebook: ChromebookForm, helpdesk: HelpdeskForm, purchase: PurchaseForm, password: PasswordForm) {
        self.employee = employee
        self.student = student
        self.chromebook = chromebook
        self.helpdesk = helpdesk
        self.purchase = purchase
        self.password = password
    }
}

struct FormField {
    var title       :   String
    var optional    :   Bool
    
    init(title: String, optional: Bool) {
        self.title = title
        self.optional = optional
    }
}

struct FormEntry {
    var title : String
    var value : String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}

struct WeatherInfo{
    var humidity    :   String
    var feels_like  :   String
    var temperature :   String
    var wind_dir    :   String
    var cloud       :   String
    var wind        :   String
    var icon        :   String
    var date        :   String
    
    init(humidity: String, feels_like: String, temperature: String, wind_dir: String, cloud: String, wind: String, icon: String, date: String) {
        self.humidity = humidity
        self.feels_like = feels_like
        self.temperature = temperature
        self.wind_dir = wind_dir
        self.cloud = cloud
        self.wind = wind
        self.icon = icon
        self.date = date
    }
}

struct NewSheetValues {
    let id      =   UUID().uuidString
    var values  :   [String:Any]
    
    init(values: [String : Any]) {
        self.values = values
    }
}
struct SheetBody:Codable{
    var range: String
    var majorDimensions: Int
    var values : [String:[String]]
}
struct MyNewSheetValues : Codable{
    var spreadsheetId: String
    var updateRange: String
    var updatedRows: String
    var updatedColumns:String
    var updatedCells: String
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spreadsheetId = try container.decode(String.self, forKey: .spreadsheetId)
        self.updateRange = try container.decode(String.self, forKey: .updateRange)
        self.updatedRows = try container.decode(String.self, forKey: .updatedRows)
        self.updatedColumns = try container.decode(String.self, forKey: .updatedColumns)
        self.updatedCells = try container.decode(String.self, forKey: .updatedCells)
    }
    
}

struct InventoryDevice{
    let id          =   UUID().uuidString
    var vendor      :   String
    var model       :   String
    var serial      :   String
    var tag         :   String
    var user        :   String
    var status      :   String
    var location    :   String
    var other       :   String?
    init(vendor: String, model: String, serial: String, tag: String, user: String, status: String, location: String, other: String? = nil) {
        self.vendor = vendor
        self.model = model
        self.serial = serial
        self.tag = tag
        self.user = user
        self.status = status
        self.location = location
        self.other = other
    }
}
extension InventoryDevice : Identifiable{}
extension InventoryDevice : Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.finalize()
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct GoogleDomainUser : Encodable {
    var primary_email                   :   String
    var name                            :   GoogleDomainUserName
    var suspended                       :   Bool
    var password                        :   String
    var change_password                 :   Bool
    var ip_whitelisted                  :   Bool
    var ims                             :   GoogleDomainUserIms
    var emails                          :   GoogleDomainUserEmails
    var addresses                       :   GoogleDomainUserAddresses
    var external_ids                    :   GoogleDomainUserExternalId
    var organizations                   :   GoogleDomainUserOrganizations
    var phones                          :   GoogleDomainUserPhones
    var org_unit_path                   :   String
    var include_in_global_address_list  :   Bool
}

private enum CodingKeys: String, CodingKey {
    case primary_email
    case name
    case suspended
    case password
    case change_password
    case ip_whitelisted
    case ims
    case emails
    case addresses
    case external_ids
    case organizations
    case phones
    case org_unit_path
    case include_in_global_address_list
}

struct GoogleDomainUserIms : Encodable{
    var type            :   String
    var im_protocol     :   String
    var im              :   String
    var primary         :   Bool
}
struct GoogleDomainUserName         : Encodable{
    var given_name      :   String
    var family_name     :   String
}
struct GoogleDomainUserEmails       :   Encodable {
    var address         :   String
    var type            :   String
    var custom_type     :   String
    var primary         :   Bool
}
struct GoogleDomainUserAddresses    :   Encodable {
    var type            :   String
    var custom_type     :   String
    var street_address  :   String
    var locality        :   String
    var region          :   String
    var postal_code     :   String
}
struct GoogleDomainUserExternalId   :   Encodable {
    var value           :   String
    var type            :   String
    var custom_type     :   String
}
struct GoogleDomainUserOrganizations :  Encodable{
    var name            :   String
    var title           :   String
    var primary         :   Bool
    var type            :   String
    var department      :   String
    var cost_center     :   String
    var floor_section   :   String
    var description     :   String
}
struct GoogleDomainUserPhones       :   Encodable{
    var value           :   String
    var type            :   String
}

struct GoogleSpreadsheet {
    var id              :   String
    var title           :   String
    var index           :   Int
    var sheet_Type      :   String
    var column_count    :   Int
    var row_count       :   Int
}

extension GoogleSpreadsheet : Identifiable{}
extension GoogleSpreadsheet : Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
