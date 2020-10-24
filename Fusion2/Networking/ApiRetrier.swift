//
//  ApiRetrier.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

final class ApiRetrier: RequestRetrier {


    private let authenticationManager: AuthenticationManager

    private let lock = NSLock()
    private var isRefreshing = false
//    private var requestsToRetry: [RequestRetryCompletion] = []

    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void)
    {}
    
}
