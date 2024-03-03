//
//  BiometricPreferencesRepository.swift
//  JobsityTV
//
//  Created by Jamyson Freire Braga on 03/03/24.
//

import Foundation

protocol BiometricPreferencesRepository {
    func update(enabled: Bool)
    func clear()
    func fetch() -> Bool
}

struct BiometricPreferencesUserDefaultsRepository: BiometricPreferencesRepository {
    private static let key = "JobsityTVBiometricPreferences"
    
    func update(enabled: Bool) {
        UserDefaults.standard.setValue(enabled, forKey: BiometricPreferencesUserDefaultsRepository.key)
    }
    
    func clear() {
        UserDefaults.standard.setValue(nil, forKey: BiometricPreferencesUserDefaultsRepository.key)
    }
    
    func fetch() -> Bool {
        UserDefaults.standard.bool(forKey: BiometricPreferencesUserDefaultsRepository.key)
    }
}
