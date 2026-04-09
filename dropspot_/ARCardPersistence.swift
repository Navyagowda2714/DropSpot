//
//  ARCardPersistence.swift
//  baby
//
import ARKit
import simd
import Foundation

final class ARCardPersistence {
    static let shared = ARCardPersistence()
    private init() {}

    private let transformsKey  = "ar_card_transforms_v2"

    // MARK: - Anchor name

    func anchorName(for card: PhotoCard) -> String {
        "photocard_\(card.id.uuidString)"
    }

    // MARK: - Save / Load singola card

    func saveTransform(_ transform: simd_float4x4, for card: PhotoCard) {
        var dict = loadAllTransformsRaw()
        dict[card.id.uuidString] = encodedTransform(transform)
        UserDefaults.standard.set(dict, forKey: transformsKey)
    }

    func loadTransform(for card: PhotoCard) -> simd_float4x4? {
        guard let dict = UserDefaults.standard.dictionary(forKey: transformsKey),
              let encoded = dict[card.id.uuidString] as? [Float] else { return nil }
        return decodedTransform(encoded)
    }

    func loadAllTransforms() -> [String: simd_float4x4] {
        var result: [String: simd_float4x4] = [:]
        for (key, value) in loadAllTransformsRaw() {
            if let encoded = value as? [Float] {
                result[key] = decodedTransform(encoded)
            }
        }
        return result
    }

    func removeTransform(for card: PhotoCard) {
        var dict = loadAllTransformsRaw()
        dict.removeValue(forKey: card.id.uuidString)
        UserDefaults.standard.set(dict, forKey: transformsKey)
    }

    func clearSavedData() {
        UserDefaults.standard.removeObject(forKey: transformsKey)
    }

    // MARK: - Private

    private func loadAllTransformsRaw() -> [String: Any] {
        UserDefaults.standard.dictionary(forKey: transformsKey) ?? [:]
    }

    private func encodedTransform(_ t: simd_float4x4) -> [Float] {
        [t.columns.0.x, t.columns.0.y, t.columns.0.z, t.columns.0.w,
         t.columns.1.x, t.columns.1.y, t.columns.1.z, t.columns.1.w,
         t.columns.2.x, t.columns.2.y, t.columns.2.z, t.columns.2.w,
         t.columns.3.x, t.columns.3.y, t.columns.3.z, t.columns.3.w]
    }

    private func decodedTransform(_ f: [Float]) -> simd_float4x4? {
        guard f.count == 16 else { return nil }
        return simd_float4x4(columns: (
            SIMD4<Float>(f[0],  f[1],  f[2],  f[3]),
            SIMD4<Float>(f[4],  f[5],  f[6],  f[7]),
            SIMD4<Float>(f[8],  f[9],  f[10], f[11]),
            SIMD4<Float>(f[12], f[13], f[14], f[15])
        ))
    }
}

