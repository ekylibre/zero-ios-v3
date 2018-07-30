//
//  Authentification.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 25/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation
import OAuthSwift
import UIKit

public class AuthentificationService: OAuthViewController {

    func authentificate(username: String, password: String) -> String? {

        let oauthSwift = OAuth2Swift(
            consumerKey: "3b6579e1ce312d7b0fdf8f2f0eb61c9d644e3081f102264c7e5d2a999926429f",
            consumerSecret: "c7e7749a8bb4e3bf67d0402b6a1b06707717d59f41e304b466a32b86b8873d29",
            authorizeUrl: "https://ekylibre-test.com/oauth/authorize",
            accessTokenUrl: "https://ekylibre-test.com/oauth/token",
            responseType: "token"
        )

        return postRequest(oauthSwift: oauthSwift, username: username, password: password)
    }

    func postRequest(oauthSwift: OAuth2Swift, username: String, password: String) -> String? {
        var token: String?
        var parameters = OAuthSwift.Parameters()

        parameters["grant_type"] = "password"
        parameters["username"] = username
        parameters["password"] = password

        let _ = oauthSwift.client.request(
            "https://ekylibre-test.com/oauth/token",
            method: .POST,
            parameters: parameters,
            headers: ["scope": "public read:profile read:lexicon read:plots read:crops read:interventions write:interventions read:equipment write:equipment read:articles write:articles read:person write:person"],
            success: { response in
                let jsonResult = try? response.jsonObject()
                let jsonDict = jsonResult as! [String: AnyObject]

                token = jsonDict["access_token"] as? String
                print("JsonDict: \(jsonResult!)")
        },
            failure: { error in
                print("ErrorRequest: \(error.localizedDescription)")
        })

        return token
    }
}
