//
//  AppDependency.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import UIKit
import PhoneNumberKit

typealias AllDependencies = HasAuthenticationManager

//typealias AllLoginDependencies = HasLoginAppleService & HasLoginGoogleService & HasLoginFacebookService

protocol HasDummyManager {}

protocol HasAuthenticationManager {
    var authenticationManager: AuthenticationManager { get }
}

struct AppDependency: AllDependencies {
    //let realmManager: RealmManager
    let apiService: ApiService
    let authenticationManager: AuthenticationManager
    

    init() {
        //realmManager = RealmManager()
        authenticationManager = AuthenticationManager()
        apiService = ApiService(authenticationManager: authenticationManager)
    }
}
