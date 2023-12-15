//
//  .env.swift
//  wchs
//
//  Created by Paul Crews on 11/3/23.
//

import Foundation
import UIKit
import GoogleSignInSwift
import GoogleSignIn
import OpenAIKit


let google_key = "AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0"
let google_customer = "C01oc0sgs"
let google_domain = "thewcs.org"

let atera_key = "7c215afdf2a346df8469ba88dc909771"

let mosyle_key = "824442824a5c2101990114a852da895d50665c1dd0c4aacac151cd526d85258d" 

let weather_key = "a01c385d98bf441faa6122931231211"


let data_set_id = "1STiiQXLaQ99sj5GYwI1SvJxK1QhLgBCSPiTSkDcwNIQ"

let gpt_key = "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"

//let openAI = OpenAIKit(apiToken: gpt_key, organization: "wchs")

func application(
  _ app: UIApplication,
  open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {
  var handled: Bool
    
  handled = GIDSignIn.sharedInstance.handle(url)
  if handled {
    return true
  }

  // Handle other custom URL types.

  // If not handled by this app, return false.
  return false
}
