//
//  GoogleService.swift
//  PrayerMate
//
//  Created by eman shedeed on 4/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
class GoogleService: GTLRCalendarService,NSCoding {
    var authorizers: GTMFetcherAuthorizationProtocol?

    init(authorizers: GTMFetcherAuthorizationProtocol?) {
        self.authorizers = authorizers
        super.init()
        self.apiKey = "AIzaSyCf6R_q6YPEBz64LR3LYCsiUu-JFGDTFnQ"
        self.authorizer = authorizers
    }

    required convenience init(coder aDecoder: NSCoder) {
        let authorizers = aDecoder.decodeObject(forKey: "authorizers") as! GTMFetcherAuthorizationProtocol
        self.init(authorizers: authorizers)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(authorizers, forKey: "authorizers")

    }
}
