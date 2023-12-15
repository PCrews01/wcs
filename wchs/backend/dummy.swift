////
////  dummy.swift
////  wchs
////
////  Created by Paul Crews on 11/12/23.
////
//
import Foundation

let d_user:GoogleDomainUser = GoogleDomainUser(
    primary_email: "",
    name: GoogleDomainUserName(given_name: "", family_name: ""),
    suspended: true,
    password: "",
    change_password: false,
    ip_whitelisted: false,
    ims: GoogleDomainUserIms(type: "",
                             im_protocol: "",
                             im: "",
                             primary: false),
    emails: GoogleDomainUserEmails(address: "",
                                   type: "",
                                   custom_type: "",
                                   primary: false),
    addresses: GoogleDomainUserAddresses(type: "",
                                         custom_type: "",
                                         street_address: "",
                                         locality: "",
                                         region: "",
                                         postal_code: ""),
    external_ids: GoogleDomainUserExternalId(value: "",
                                             type: "",
                                             custom_type: ""),
    organizations: GoogleDomainUserOrganizations(name: "",
                                                 title: "",
                                                 primary: false,
                                                 type: "",
                                                 department: "",
                                                 cost_center: "",
                                                 floor_section: "",
                                                 description: ""),
    phones: GoogleDomainUserPhones(value: "",
                                   type: ""),
    org_unit_path: "",
    include_in_global_address_list: false)
