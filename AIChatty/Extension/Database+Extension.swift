//
//  Database+Extension.swift
//  AIChatty
//

import Blackbird

extension Blackbird.Database {

    func upsert(model: some BlackbirdModel) async {
        do {
            try await model.write(to: self)
        } catch {
            debugPrint(error)
        }
    }
}
