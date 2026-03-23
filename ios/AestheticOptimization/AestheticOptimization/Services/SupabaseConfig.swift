import Foundation

struct SupabaseConfig {
    let url: URL
    let anonKey: String

    static func load() throws -> SupabaseConfig {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let anonKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
            !urlString.isEmpty,
            !anonKey.isEmpty,
            let url = URL(string: urlString)
        else {
            throw SupabaseConfigError.missingValues
        }

        return SupabaseConfig(url: url, anonKey: anonKey)
    }
}

enum SupabaseConfigError: LocalizedError {
    case missingValues

    var errorDescription: String? {
        "Missing Supabase configuration. Add SUPABASE_URL and SUPABASE_ANON_KEY to Info.plist."
    }
}
