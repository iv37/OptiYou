import Foundation

struct AuthSession: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int?
    let tokenType: String?
    let user: AuthUser

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case user
    }
}

struct AuthUser: Codable {
    let id: String
    let email: String?
}

struct LoginCredentials: Encodable {
    let email: String
    let password: String
}

enum AuthMode: Hashable {
    case login
    case signup
}

final class AuthService {
    static let shared = AuthService()

    private let keychainService = "com.openai.aestheticoptimization.auth"
    private let keychainAccount = "supabase-session"

    private init() {}

    func signUp(email: String, password: String) async throws -> AuthSession {
        let payload = LoginCredentials(email: email, password: password)
        return try await request(
            path: "/auth/v1/signup",
            method: "POST",
            body: payload,
            accessToken: nil
        )
    }

    func login(email: String, password: String) async throws -> AuthSession {
        let payload = LoginCredentials(email: email, password: password)
        return try await request(
            path: "/auth/v1/token?grant_type=password",
            method: "POST",
            body: payload,
            accessToken: nil
        )
    }

    func fetchCurrentUser(session: AuthSession) async throws -> AuthUser {
        try await request(
            path: "/auth/v1/user",
            method: "GET",
            body: Optional<String>.none,
            accessToken: session.accessToken
        )
    }

    func logout(session: AuthSession) async {
        do {
            let _: EmptyResponse = try await request(
                path: "/auth/v1/logout",
                method: "POST",
                body: Optional<String>.none,
                accessToken: session.accessToken
            )
        } catch {
            // Ignore logout network failures and still clear the local session.
        }

        clearStoredSession()
    }

    func storeSession(_ session: AuthSession) throws {
        let data = try JSONEncoder().encode(session)
        try KeychainHelper.save(data, service: keychainService, account: keychainAccount)
    }

    func readStoredSession() throws -> AuthSession? {
        guard let data = try KeychainHelper.read(service: keychainService, account: keychainAccount) else {
            return nil
        }

        return try JSONDecoder().decode(AuthSession.self, from: data)
    }

    func clearStoredSession() {
        KeychainHelper.delete(service: keychainService, account: keychainAccount)
    }

    private func request<Response: Decodable, Body: Encodable>(
        path: String,
        method: String,
        body: Body?,
        accessToken: String?
    ) async throws -> Response {
        let config = try SupabaseConfig.load()
        guard let url = buildURL(baseURL: config.url, path: path) else {
            throw SupabaseServiceError.requestFailed(statusCode: -1, message: "Invalid Supabase URL.")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(config.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse

        guard let httpResponse, (200 ... 299).contains(httpResponse.statusCode) else {
            let authError = try? JSONDecoder().decode(SupabaseAPIError.self, from: data)
            throw SupabaseServiceError.requestFailed(
                statusCode: httpResponse?.statusCode ?? -1,
                message: authError?.message ?? "Request failed."
            )
        }

        if Response.self == EmptyResponse.self {
            return EmptyResponse() as! Response
        }

        return try JSONDecoder().decode(Response.self, from: data)
    }

    private func buildURL(baseURL: URL, path: String) -> URL? {
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        guard let slashIndex = trimmed.firstIndex(of: "/") else {
            return baseURL.appendingPathComponent(trimmed)
        }

        let pathAndQuery = String(trimmed[slashIndex...])
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = pathAndQuery.components(separatedBy: "?").first ?? pathAndQuery
        components?.percentEncodedQuery = pathAndQuery.components(separatedBy: "?").dropFirst().joined(separator: "?")
        return components?.url
    }
}

private struct EmptyResponse: Decodable {}

struct SupabaseAPIError: Decodable {
    let message: String
}

enum SupabaseServiceError: LocalizedError {
    case requestFailed(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case let .requestFailed(statusCode, message):
            return "Supabase request failed (\(statusCode)): \(message)"
        }
    }
}
