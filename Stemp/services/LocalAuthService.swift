//
//  LocalAuthService.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 07/11/24.
//

import Foundation
import LocalAuthentication

class LocalAuthService{

    private let authenticatorContext = LAContext()
    private var error: NSError?

    func authorizeUser(completion: @escaping(_ autenticao: Bool) -> Void) {
        if authenticatorContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authenticatorContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Vamos confirmar sua identidade para realizar essa operação"
            ) { sucesso, error in completion(sucesso) }
        }
    }

}

