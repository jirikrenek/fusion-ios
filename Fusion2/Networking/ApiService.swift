//
//  ApiService.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Errors

enum ServerError: Error {
    case invalidResponse
    case clientError(code: Int, message: String)
    case invalidResponseCode(statusCode: Int)
    case timeout
    case invalidRequest
    case missingToken
}

// MARK: - ErrorPayload

struct ErrorPayload: Decodable {
    var success: Bool
    var data: Error

    struct Error: Decodable {
        var errorMessage: String?
    }
}

// MARK: - ApiService

final class ApiService {

    struct StatusCode {
        static let ok = 200
        static let created = 201
        static let accepted = 202
        static let unauthorized = 401
        static let notFound = 404

        static let success = 200...299
        static let clientError = 400...499
        static let serverError = 500...599

        static let valid = 200...499
    }

    static let jsonContentType = "application/json"
//    private let decoder: JSONDecoder

    private let authenticationManager: AuthenticationManager
    //let sessionManager: SessionManager

    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
        
        
    }
        //let configuration = URLSessionConfiguration.default
        //configuration.timeoutIntervalForRequest = 60
        //configuration.timeoutIntervalForResource = 60
//
        //self.sessionManager = Alamofire.SessionManager(configuration: configuration)
//        self.sessionManager.adapter = ApiAdapter(authenticationManager: authenticationManager,
    //                                             realmManager: realmManager)
  //      self.sessionManager.retrier = ApiRetrier(authenticationManager: authenticationManager)

        //self.decoder = Constants.jsonDecoder
    

    // MARK: - Requests

    

    // MARK: - Helpers

    private func validateResponse(response: URLResponse?, data: Data?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServerError.invalidResponse
        }

        if !(ApiService.StatusCode.valid ~= httpResponse.statusCode) {
            throw ServerError.invalidResponseCode(statusCode: httpResponse.statusCode)
        }

        if !(ApiService.StatusCode.success ~= httpResponse.statusCode) {
            //let data = data
            //let errorPayload = try? decoder.decode(ErrorPayload.self, from: data) {
            //throw ServerError.clientError(code: httpResponse.statusCode, message: errorPayload.data.errorMessage ?? "")
        }
    }
}
