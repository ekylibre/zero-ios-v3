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

    func authentificate(consumerKey: String, consumerSecret: String) -> String? {

        var token: String!
        let oauth2 = OAuth2Swift(
            consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            authorizeUrl: "https://ekylibre.com/oauth/authorize",
            responseType: "token"
        )
        let state = generateState(withLength: 20)

        oauth2.authorize(
            withCallbackURL: URL(string: "Clic&Farm-iOS://oauth-callback")!,
            scope: "",
            state: state,
            success: { credential, response, parameters in
                token = credential.oauthToken
                print("OAuth Token: \(token)")
                self.launchRequest(oauth2: oauth2)
                self.launchPost(oauth2: oauth2)
                            },
            failure: { error in
                print("Error: \(error.localizedDescription)")
            }
        )
        launchRequest(oauth2: oauth2)
        launchPost(oauth2: oauth2)
        print("Oauth2: \(oauth2)")
        return token
    }

    func launchRequest(oauth2: OAuth2Swift) {
        let parameters: Dictionary = Dictionary<String, AnyObject>()
        let request = oauth2.client.get(
            "https://ekylibre.com/?access_token=\(oauth2.client.credential.oauthToken)",
            parameters: parameters,
            success: { response in
                let jsonDict = try? response.jsonObject()

                print("JsonDict: \(String(describing: jsonDict))")
                print("Response: \(response)")
            },
            failure: { error in
                print("Error: \(error.localizedDescription)")
            }
        )

        print("Request: \(request!)")
    }

    func launchPost(oauth2: OAuth2Swift) {
        let token = oauth2.client.credential.oauthToken
        let parameters = ["token": token]
        let post = oauth2.client.post(
            "https://ekylibre.com",
            parameters: parameters,
            success: {
                data in
                let jsonDict = try? data.jsonObject()

                print("Json: \(String(describing: jsonDict))")
                print("data: \(data)")
            },
            failure: { error in
                print("error: \(error.localizedDescription)")
            }
        )

        print("Post: \(post!)")
    }
}
