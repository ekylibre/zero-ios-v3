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

open class AuthentificationService {

    public var oauth2: OAuth2PasswordGrant

    public init(username: String, password: String) {
        oauth2 = OAuth2PasswordGrant(settings: [
            "client_id": "3b6579e1ce312d7b0fdf8f2f0eb61c9d644e3081f102264c7e5d2a999926429f",
            "client_secret": "c7e7749a8bb4e3bf67d0402b6a1b06707717d59f41e304b466a32b86b8873d29",
            "token_uri": "https://ekylibre-test.com/oauth/token",
            "username": username,
            "password": password,
            "grant_type": "password",
            "scope": "public read:profile read:lexicon read:plots read:crops read:interventions write:interventions read:equipment write:equipment read:articles write:articles read:person write:person",
            "verbose": true
            ] as OAuth2JSON)
    }

    public func authorize(presenting view: UIViewController) {

        oauth2.authorizeEmbedded(from: view) { (authParameters, error) in
            if let _ = authParameters {
                print("\n\(authParameters!)\n")
                UserDefaults.standard.set(true, forKey: "LOGGED_IN")
            }
            else {
                UserDefaults.standard.set(false, forKey: "LOGGED_IN")
                print("\nAuthorization was canceled or went wrong: \(String(describing: error?.description))\n")
            }
        }
    }

    public func logout() {
        print("Logout func")
        oauth2.forgetTokens()
        UserDefaults.standard.set(false, forKey: "LOGGED_IN")
        print("Logged status: \(String(describing: UserDefaults.standard.value(forKey: "LOGGED_IN")))")
    }
}
