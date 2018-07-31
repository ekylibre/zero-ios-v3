//
//  Authentification.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 25/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation
import UIKit
import OAuth2

public class AuthentificationService: UIViewController {
/*
    let temporaryKey = "SimpleEncryptionKey"

    func saveToken(token: String?) {
        if token != nil {
            let securedToken = KeychainService.stringToNSDATA(string: token!)

            KeychainService.update(key: temporaryKey, data: securedToken)
        }
    }

    func loadTokenIfStillValid() -> String? {
        if let securedToken = KeychainService.load(key: temporaryKey) {
            let token = KeychainService.NSDATAtoString(data: securedToken)

            return token
        }
        return nil
    }

    func postRequest(oauthSwift: OAuth2Swift, username: String, password: String, parameters: OAuth2Swift.Parameters) {
        let _ = oauthSwift.client.request(
            "https://ekylibre-test.com/oauth/token",
            method: .POST,
            parameters: parameters,
            headers: [:],
            success: { response in
                let jsonResult = try? response.jsonObject()
                let jsonDict = jsonResult as! [String: AnyObject]
                let access_token = jsonDict["access_token"] as? String
                let refresh_token = jsonDict["refresh_token"] as? String

                oauthSwift.client.credential.oauthToken = access_token!
                oauthSwift.client.credential.oauthRefreshToken = refresh_token!
                //self.saveToken(token: access_token)
                print("JsonDict: \(jsonResult!)")
                print("OauthToken: \(oauthSwift.client.credential.oauthToken).")
        },
            failure: { error in
                print("Post error: \(error)")
        })
    }

    func getRequest(oauthSwift: OAuth2Swift, username: String, password: String, parameters: OAuth2Swift.Parameters) {
        let _ = oauthSwift.client.request(
            "https://ekylibre-test.com/oauth/token",
            method: .GET,
            parameters: parameters,
            headers: [:],
            success: { response in
                let jsonResult = try? response.jsonObject()
                let jsonDict = jsonResult as! [String: AnyObject]

                print("JsonDict: \(jsonDict)")
                print("JsonResult: \(String(describing: jsonResult))")
                print("Get response: \(response)")
        },
            failure: { error in
                print("Get error: \(error.localizedDescription)")
        })
        
    }

    func authentificate(username: String, password: String) {
        let oauthSwift = OAuth2Swift(
            consumerKey: "3b6579e1ce312d7b0fdf8f2f0eb61c9d644e3081f102264c7e5d2a999926429f",
            consumerSecret: "c7e7749a8bb4e3bf67d0402b6a1b06707717d59f41e304b466a32b86b8873d29",
            authorizeUrl: "https://ekylibre-test.com/oauth/authorize",
            accessTokenUrl: "https://ekylibre-test.com/oauth/token",
            responseType: "password"
        )
        var parameters = OAuth2Swift.Parameters()

        parameters["client_id"] = "3b6579e1ce312d7b0fdf8f2f0eb61c9d644e3081f102264c7e5d2a999926429f"
        parameters["client_secret"] = "c7e7749a8bb4e3bf67d0402b6a1b06707717d59f41e304b466a32b86b8873d29"
        parameters["grant_type"] = "password"
        parameters["username"] = username
        parameters["password"] = password
        parameters["scope"] = "public read:profile read:lexicon read:plots read:crops read:interventions write:interventions read:equipment write:equipment read:articles write:articles read:person write:person"

        postRequest(oauthSwift: oauthSwift, username: username, password: password, parameters: parameters)
        //getRequest(oauthSwift: oauthSwift, username: username, password: password, parameters: parameters)
        print("OauthToken: \(oauthSwift.client.credential.oauthToken).")
    }*/
}
