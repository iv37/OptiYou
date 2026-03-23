import Foundation

struct ProfileRecord: Codable {
    let id: UUID?
    let userID: String
    let email: String
    let age: Int?
    let gender: String?
    let heightCM: Int?
    let weightKG: Double?
    let neckCM: Double?
    let waistCM: Double?
    let hipCM: Double?
    let bodyFatEstimate: Double?
    let skinGoals: [String]
    let hairGoals: [String]
    let bodyGoals: [String]
    let groomingGoals: [String]
    let sleepHours: Double?
    let hydrationLiters: Double?
    let exerciseDays: Int?
    let dietQuality: String?
    let dietNotes: String?
    let calorieIntake: Int?
    let onboardingCompleted: Bool
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case email
        case age
        case gender
        case heightCM = "height_cm"
        case weightKG = "weight_kg"
        case neckCM = "neck_cm"
        case waistCM = "waist_cm"
        case hipCM = "hip_cm"
        case bodyFatEstimate = "body_fat_estimate"
        case skinGoals = "skin_goals"
        case hairGoals = "hair_goals"
        case bodyGoals = "body_goals"
        case groomingGoals = "grooming_goals"
        case sleepHours = "sleep_hours"
        case hydrationLiters = "hydration_liters"
        case exerciseDays = "exercise_days"
        case dietQuality = "diet_quality"
        case dietNotes = "diet_notes"
        case calorieIntake = "calorie_intake"
        case onboardingCompleted = "onboarding_completed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ProfileInput {
    let age: String
    let gender: String
    let heightFeet: String
    let heightInches: String
    let weightPounds: String
    let neckFeet: String
    let neckInches: String
    let waistFeet: String
    let waistInches: String
    let hipFeet: String
    let hipInches: String
    let skinGoals: [String]
    let hairGoals: [String]
    let bodyGoals: [String]
    let groomingGoals: [String]
    let sleepHours: String
    let hydrationOunces: String
    let exerciseDays: String
    let dietQuality: String
    let dietNotes: String
    let calorieIntake: String
}

final class ProfileService {
    static let shared = ProfileService()

    private init() {}

    func fetchProfile(session: AuthSession) async throws -> ProfileRecord? {
        let records: [ProfileRecord] = try await request(
            path: "/rest/v1/profiles?select=*&user_id=eq.\(session.user.id)&limit=1",
            method: "GET",
            body: Optional<String>.none,
            accessToken: session.accessToken
        )

        return records.first
    }

    func upsertProfile(input: ProfileInput, session: AuthSession) async throws -> ProfileRecord {
        let heightCM = Self.heightCM(feetString: input.heightFeet, inchesString: input.heightInches)
        let neckCM = Self.lengthCM(feetString: input.neckFeet, inchesString: input.neckInches)
        let waistCM = Self.lengthCM(feetString: input.waistFeet, inchesString: input.waistInches)
        let hipCM = input.gender == "Female" ? Self.lengthCM(feetString: input.hipFeet, inchesString: input.hipInches) : nil
        let bodyFatEstimate = Self.bodyFatEstimate(
            gender: input.gender,
            heightCM: heightCM,
            neckCM: neckCM,
            waistCM: waistCM,
            hipCM: hipCM
        )
        let payload = ProfileRecord(
            id: nil,
            userID: session.user.id,
            email: session.user.email ?? "",
            age: Int(input.age),
            gender: input.gender,
            heightCM: heightCM,
            weightKG: Self.weightKG(fromPoundsString: input.weightPounds),
            neckCM: neckCM,
            waistCM: waistCM,
            hipCM: hipCM,
            bodyFatEstimate: bodyFatEstimate,
            skinGoals: input.skinGoals,
            hairGoals: input.hairGoals,
            bodyGoals: input.bodyGoals,
            groomingGoals: input.groomingGoals,
            sleepHours: Self.sleepHours(from: input.sleepHours),
            hydrationLiters: Self.hydrationLiters(fromOuncesString: input.hydrationOunces),
            exerciseDays: Int(input.exerciseDays),
            dietQuality: input.dietQuality,
            dietNotes: Self.normalizedDietNotes(input.dietNotes),
            calorieIntake: Int(input.calorieIntake),
            onboardingCompleted: true,
            createdAt: nil,
            updatedAt: nil
        )

        let records: [ProfileRecord] = try await request(
            path: "/rest/v1/profiles",
            method: "POST",
            body: [payload],
            accessToken: session.accessToken,
            extraHeaders: [
                "Prefer": "resolution=merge-duplicates,return=representation"
            ]
        )

        guard let profile = records.first else {
            throw SupabaseServiceError.requestFailed(statusCode: -1, message: "Profile save returned no record.")
        }

        return profile
    }

    private func request<Response: Decodable, Body: Encodable>(
        path: String,
        method: String,
        body: Body?,
        accessToken: String,
        extraHeaders: [String: String] = [:]
    ) async throws -> Response {
        let config = try SupabaseConfig.load()
        guard let url = buildURL(baseURL: config.url, path: path) else {
            throw SupabaseServiceError.requestFailed(statusCode: -1, message: "Invalid Supabase URL.")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(config.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for (header, value) in extraHeaders {
            request.setValue(value, forHTTPHeaderField: header)
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse

        guard let httpResponse, (200 ... 299).contains(httpResponse.statusCode) else {
            let apiError = try? JSONDecoder().decode(SupabaseAPIError.self, from: data)
            throw SupabaseServiceError.requestFailed(
                statusCode: httpResponse?.statusCode ?? -1,
                message: apiError?.message ?? "Profile request failed."
            )
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

    static func heightCM(feetString: String, inchesString: String) -> Int? {
        guard let centimeters = lengthCM(feetString: feetString, inchesString: inchesString) else { return nil }
        return Int(round(centimeters))
    }

    static func lengthCM(feetString: String, inchesString: String) -> Double? {
        guard let feet = Double(feetString), let inches = Double(inchesString) else { return nil }
        let totalInches = (feet * 12) + inches
        return (totalInches * 2.54 * 10).rounded() / 10
    }

    static func weightKG(fromPoundsString poundsString: String) -> Double? {
        guard let pounds = Double(poundsString) else { return nil }
        return (pounds * 0.45359237 * 10).rounded() / 10
    }

    static func hydrationLiters(fromOuncesString ouncesString: String) -> Double? {
        guard let ounces = Double(ouncesString) else { return nil }
        return (ounces * 0.0295735 * 10).rounded() / 10
    }

    static func sleepHours(from value: String) -> Double? {
        value == "12+" ? 12 : Double(value)
    }

    static func normalizedDietNotes(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    static func feetAndInchesStrings(from centimeters: Double?) -> (feet: String, inches: String) {
        guard let centimeters, centimeters >= 0 else {
            return ("", "")
        }

        let totalInches = centimeters / 2.54
        let feet = Int(totalInches / 12)
        let inches = ((totalInches - Double(feet * 12)) * 10).rounded() / 10
        return (String(feet), String(format: "%.1f", inches))
    }

    static func heightStrings(from centimeters: Int?) -> (feet: String, inches: String) {
        feetAndInchesStrings(from: centimeters.map(Double.init))
    }

    static func poundsString(from kilograms: Double?) -> String {
        guard let kilograms else { return "" }
        return String(format: "%.1f", kilograms / 0.45359237)
    }

    static func ouncesString(from liters: Double?) -> String {
        guard let liters else { return "" }
        return String(format: "%.1f", liters * 33.814)
    }

    static func sleepHoursString(from hours: Double?) -> String {
        guard let hours else { return "" }
        if hours >= 12 {
            return "12+"
        }
        if abs(hours.rounded() - hours) < 0.001 {
            return String(Int(hours))
        }
        return String(format: "%.1f", hours)
    }

    static func bodyFatEstimate(
        gender: String,
        heightCM: Int?,
        neckCM: Double?,
        waistCM: Double?,
        hipCM: Double?
    ) -> Double? {
        guard let heightCM, let neckCM, let waistCM else { return nil }

        let heightInches = Double(heightCM) / 2.54
        let neckInches = neckCM / 2.54
        let waistInches = waistCM / 2.54

        guard heightInches > 0, neckInches > 0, waistInches > 0 else { return nil }

        let estimate: Double?
        if gender == "Female" {
            guard let hipCM else { return nil }
            let hipInches = hipCM / 2.54
            let logInput = waistInches + hipInches - neckInches
            guard hipInches > 0, logInput > 0 else { return nil }
            estimate = 163.205 * log10(logInput) - 97.684 * log10(heightInches) - 78.387
        } else {
            let logInput = waistInches - neckInches
            guard logInput > 0 else { return nil }
            estimate = 86.010 * log10(logInput) - 70.041 * log10(heightInches) + 36.76
        }

        guard let estimate else { return nil }
        return max(0, (estimate * 10).rounded() / 10)
    }

    static func bodyFatCategory(gender: String?, estimate: Double?) -> String? {
        guard let gender, let estimate else { return nil }

        if gender == "Female" {
            switch estimate {
            case ..<14: return "Essential fat"
            case ..<21: return "Athletes"
            case ..<25: return "Fitness"
            case ..<32: return "Average"
            default: return "Obese"
            }
        }

        switch estimate {
        case ..<6: return "Essential fat"
        case ..<14: return "Athletes"
        case ..<18: return "Fitness"
        case ..<25: return "Average"
        default: return "Obese"
        }
    }

    static func dietInsight(from notes: String?, dietQuality: String?) -> String? {
        let text = (notes ?? "").lowercased()

        if text.contains("fast food") || text.contains("fried") || text.contains("soda") || text.contains("takeout") || text.contains("chips") {
            return "Current food pattern looks convenience-heavy, so the first nutrition win is cleaner daily choices."
        }

        if text.contains("protein") || text.contains("chicken") || text.contains("eggs") || text.contains("greek yogurt") || text.contains("steak") {
            return "Protein intake already looks intentional, so the next step is tightening meal quality and consistency."
        }

        if text.contains("skip") || text.contains("don't eat") || text.contains("one meal") || text.contains("snack") {
            return "Meal consistency looks uneven, so a steadier eating rhythm should help recovery and body-composition progress."
        }

        if text.contains("fruit") || text.contains("vegetable") || text.contains("rice") || text.contains("oats") || text.contains("salad") {
            return "Food quality looks fairly solid, so the next step is portion control and making the routine easier to repeat."
        }

        if let dietQuality {
            switch dietQuality {
            case "Poor", "Fair":
                return "Nutrition likely has the most room to improve, so we’ll keep recommendations simple and sustainable."
            case "Decent":
                return "Nutrition looks workable, and the main opportunity is more consistency across the week."
            case "Good", "Strong":
                return "Nutrition already looks like a strength, so the focus can stay on precision rather than overhaul."
            default:
                break
            }
        }

        return nil
    }
}
