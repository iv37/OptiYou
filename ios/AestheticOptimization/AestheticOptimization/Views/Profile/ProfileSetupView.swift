import SwiftUI

enum ProfileSetupMode {
    case onboarding
    case editing

    var chipText: String {
        switch self {
        case .onboarding: "Onboarding"
        case .editing: "Edit profile"
        }
    }

    var headerTitle: String {
        switch self {
        case .onboarding: "Build your dashboard."
        case .editing: "Update your profile."
        }
    }

    var headerDetail: String {
        switch self {
        case .onboarding: "We’ll use these answers to shape your results, priorities, and goals."
        case .editing: "Changes here will immediately update your dashboard, targets, and recommendations."
        }
    }

    var completeButtonTitle: String {
        switch self {
        case .onboarding: "Complete onboarding"
        case .editing: "Save changes"
        }
    }
}

private enum OnboardingStep: Int, CaseIterable {
    case profile
    case goals
    case bodyComposition
    case lifestyle
    case review

    var title: String {
        switch self {
        case .profile: "Profile"
        case .goals: "Goals"
        case .bodyComposition: "Body"
        case .lifestyle: "Lifestyle"
        case .review: "Review"
        }
    }

    var subtitle: String {
        switch self {
        case .profile: "A few details to personalize the experience."
        case .goals: "Choose what matters most right now."
        case .bodyComposition: "Add a few measurements so the dashboard estimate feels more grounded from the start."
        case .lifestyle: "A quick read on current habits."
        case .review: "Check everything before continuing."
        }
    }
}

struct ProfileSetupView: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    private let mode: ProfileSetupMode

    @State private var selectedStep: OnboardingStep = .profile
    @State private var age = ""
    @State private var gender = ""
    @State private var heightFeet = ""
    @State private var heightInches = ""
    @State private var weightPounds = ""
    @State private var neckFeet = "0"
    @State private var neckInches = "0.0"
    @State private var waistFeet = "0"
    @State private var waistInches = "0.0"
    @State private var hipFeet = "0"
    @State private var hipInches = "0.0"
    @State private var skinGoals: Set<String> = []
    @State private var hairGoals: Set<String> = []
    @State private var bodyGoals: Set<String> = []
    @State private var groomingGoals: Set<String> = []
    @State private var sleepHours = ""
    @State private var hydrationOunces = ""
    @State private var exerciseDays = ""
    @State private var dietQuality = ""
    @State private var dietNotes = ""
    @State private var calorieIntake = ""

    private let ageOptions = Array(1...99).map(String.init)
    private let genderOptions = ["Male", "Female"]
    private let feetOptions = Array(3...8).map(String.init)
    private let inchesOptions = stride(from: 0.0, through: 11.5, by: 0.5).map { String(format: "%.1f", $0) }
    private let measurementFeetOptions = Array(0...8).map(String.init)
    private let measurementInchOptions = (0...119).map { String(format: "%.1f", Double($0) / 10) }
    private let sleepOptions = Array(0...12).map(String.init) + ["12+"]
    private let exerciseDayOptions = Array(0...7).map(String.init)
    private let skinGoalOptions = ["Clearer skin", "Reduce redness", "Smoother texture", "Calmer acne-prone skin"]
    private let hairGoalOptions = ["Hair loss prevention", "Better density presentation", "Healthier scalp", "Stronger styling"]
    private let bodyGoalOptions = ["Leaner physique", "Build strength", "Lower body fat", "More athletic look"]
    private let groomingGoalOptions = ["Sharper haircut", "Cleaner beard lines", "Prevent ingrown hairs", "More polished daily grooming"]
    private let dietQualityOptions = ["Poor", "Fair", "Decent", "Good", "Strong"]

    init(mode: ProfileSetupMode = .onboarding, profile: ProfileRecord? = nil) {
        self.mode = mode

        if let profile {
            let height = ProfileService.heightStrings(from: profile.heightCM)
            let neck = ProfileService.feetAndInchesStrings(from: profile.neckCM)
            let waist = ProfileService.feetAndInchesStrings(from: profile.waistCM)
            let hip = ProfileService.feetAndInchesStrings(from: profile.hipCM)
            _age = State(initialValue: profile.age.map(String.init) ?? "")
            _gender = State(initialValue: profile.gender ?? "")
            _heightFeet = State(initialValue: height.feet)
            _heightInches = State(initialValue: height.inches)
            _weightPounds = State(initialValue: ProfileService.poundsString(from: profile.weightKG))
            _neckFeet = State(initialValue: neck.feet.isEmpty ? "0" : neck.feet)
            _neckInches = State(initialValue: neck.inches.isEmpty ? "0.0" : neck.inches)
            _waistFeet = State(initialValue: waist.feet.isEmpty ? "0" : waist.feet)
            _waistInches = State(initialValue: waist.inches.isEmpty ? "0.0" : waist.inches)
            _hipFeet = State(initialValue: hip.feet.isEmpty ? "0" : hip.feet)
            _hipInches = State(initialValue: hip.inches.isEmpty ? "0.0" : hip.inches)
            _skinGoals = State(initialValue: Set(profile.skinGoals))
            _hairGoals = State(initialValue: Set(profile.hairGoals))
            _bodyGoals = State(initialValue: Set(profile.bodyGoals))
            _groomingGoals = State(initialValue: Set(profile.groomingGoals))
            _sleepHours = State(initialValue: ProfileService.sleepHoursString(from: profile.sleepHours))
            _hydrationOunces = State(initialValue: ProfileService.ouncesString(from: profile.hydrationLiters))
            _exerciseDays = State(initialValue: profile.exerciseDays.map(String.init) ?? "")
            _dietQuality = State(initialValue: profile.dietQuality ?? "")
            _dietNotes = State(initialValue: profile.dietNotes ?? "")
            _calorieIntake = State(initialValue: profile.calorieIntake.map(String.init) ?? "")
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            TabView(selection: $selectedStep) {
                profileStep.tag(OnboardingStep.profile)
                goalsStep.tag(OnboardingStep.goals)
                bodyCompositionStep.tag(OnboardingStep.bodyComposition)
                lifestyleStep.tag(OnboardingStep.lifestyle)
                reviewStep.tag(OnboardingStep.review)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            footer
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 28)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            ChipView(text: mode.chipText, tint: AppTheme.primary)
            Text(mode.headerTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.foreground)
            Text(mode.headerDetail)
                .font(.headline)
                .foregroundStyle(AppTheme.muted)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Step \(selectedStep.rawValue + 1) of \(OnboardingStep.allCases.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.muted)
                    Spacer()
                    Text(selectedStep.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.primary)
                }

                ProgressView(value: Double(selectedStep.rawValue + 1), total: Double(OnboardingStep.allCases.count))
                    .tint(AppTheme.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 18)
    }

    private var profileStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                stepIntro(for: .profile)
                VStack(spacing: 12) {
                    menuField(title: "Age", selection: $age, options: ageOptions, placeholder: "Select one")
                    menuField(title: "Gender", selection: $gender, options: genderOptions, placeholder: "Select one")

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Height")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.muted)
                        HStack(spacing: 12) {
                            menuField(title: "Feet", selection: $heightFeet, options: feetOptions, placeholder: "ft", compactLabel: true)
                            menuField(title: "Inches", selection: $heightInches, options: inchesOptions, placeholder: "in", compactLabel: true)
                        }
                    }

                    decimalField(title: "Weight (lb)", text: $weightPounds, keyboard: .decimalPad, placeholder: "Enter your weight")
                }
                .padding(20)
                .glassCard()
            }
        }
    }

    private var goalsStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                stepIntro(for: .goals)
                goalSection(title: "Skin goals", options: skinGoalOptions, selection: $skinGoals)
                goalSection(title: "Hair goals", options: hairGoalOptions, selection: $hairGoals)
                goalSection(title: "Body goals", options: bodyGoalOptions, selection: $bodyGoals)
                goalSection(title: "Grooming goals", options: groomingGoalOptions, selection: $groomingGoals)
            }
        }
    }

    private var lifestyleStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                stepIntro(for: .lifestyle)
                VStack(spacing: 12) {
                    menuField(title: "Sleep (hours per day)", selection: $sleepHours, options: sleepOptions, placeholder: "Select one")
                    decimalField(title: "Daily water intake (oz)", text: $hydrationOunces, keyboard: .decimalPad)
                    menuField(title: "Exercise days per week", selection: $exerciseDays, options: exerciseDayOptions, placeholder: "Select one")

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Diet quality")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.muted)
                        Menu {
                            ForEach(dietQualityOptions, id: \.self) { option in
                                Button(option) {
                                    dietQuality = option
                                }
                            }
                        } label: {
                            HStack {
                                Text(dietQuality.isEmpty ? "Select one" : dietQuality)
                                    .foregroundStyle(dietQuality.isEmpty ? AppTheme.muted : AppTheme.foreground)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(AppTheme.muted)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .insetSurface()
                    }

                    wholeNumberField(title: "Calorie intake", text: $calorieIntake, keyboard: .numberPad)

                    multilineField(
                        title: "What do you usually eat?",
                        text: $dietNotes,
                        prompt: "Example: eggs and coffee in the morning, takeout for lunch, chicken and rice for dinner."
                    )
                }
                .padding(20)
                .glassCard()
            }
        }
    }

    private var bodyCompositionStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                stepIntro(for: .bodyComposition)

                VStack(alignment: .leading, spacing: 14) {
                    measurementGroup(title: "Neck", feet: $neckFeet, inches: $neckInches)
                    measurementGroup(title: "Waist", feet: $waistFeet, inches: $waistInches)

                    if gender == "Female" {
                        measurementGroup(title: "Hip", feet: $hipFeet, inches: $hipInches)
                    }
                }
                .padding(20)
                .glassCard()
            }
        }
    }

    private var reviewStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                stepIntro(for: .review)

                reviewCard(title: "Profile", lines: [
                    "Age: \(age)",
                    "Gender: \(gender)",
                    "Height: \(heightFeet) ft \(heightInches) in",
                    "Weight: \(weightPounds) lb"
                ])

                reviewCard(title: "Goals", lines: [
                    "Skin: \(joinedGoals(from: skinGoals))",
                    "Hair: \(joinedGoals(from: hairGoals))",
                    "Body: \(joinedGoals(from: bodyGoals))",
                    "Grooming: \(joinedGoals(from: groomingGoals))"
                ])

                reviewCard(title: "Body composition estimate", lines: bodyMeasurementReviewLines)

                reviewCard(title: "Lifestyle", lines: [
                    "Sleep: \(sleepHours) hours",
                    "Hydration: \(hydrationOunces) oz",
                    "Exercise: \(exerciseDays) days",
                    "Diet quality: \(dietQuality)",
                    "Calories: \(calorieIntake)",
                    "Typical meals: \(dietNotes)"
                ])

                if let profileError = appModel.profileErrorMessage {
                    Text(profileError)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.danger)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 12) {
            if let validationError = validationMessage {
                Text(validationError)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.danger)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 12) {
                Button(selectedStep == .profile ? "Back" : "Previous") {
                    goBack()
                }
                .buttonStyle(SecondaryButtonStyle())
                .disabled(selectedStep == .profile)

                Button(primaryButtonTitle) {
                    Task {
                        await goForward()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isPrimaryDisabled)
            }

            if appModel.isUsingDevBypass {
                Button(devButtonTitle) {
                    applyDevDataForCurrentStep()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .padding(.top, 16)
    }

    private var primaryButtonTitle: String {
        selectedStep == .review ? (appModel.isSavingProfile ? "Saving..." : mode.completeButtonTitle) : "Next"
    }

    private var isPrimaryDisabled: Bool {
        if selectedStep == .review {
            return appModel.isSavingProfile || validationMessage != nil
        }

        return validationMessage != nil
    }

    private var devButtonTitle: String {
        switch selectedStep {
        case .profile: "Dev: fill profile"
        case .goals: "Dev: fill goals"
        case .bodyComposition: "Dev: fill body"
        case .lifestyle: "Dev: fill lifestyle"
        case .review: "Dev: fill all"
        }
    }

    private var validationMessage: String? {
        switch selectedStep {
        case .profile:
            if !ageOptions.contains(age) { return "Choose an age." }
            if !genderOptions.contains(gender) { return "Choose male or female." }
            if !feetOptions.contains(heightFeet) || !inchesOptions.contains(heightInches) { return "Choose height." }
            guard let pounds = Double(weightPounds), pounds >= 0, pounds <= 1400 else { return "Enter weight from 0 to 1400 lb." }
            if !hasAtMostOneDecimal(weightPounds) { return "Weight should use at most one decimal place." }
        case .goals:
            if skinGoals.isEmpty || hairGoals.isEmpty || bodyGoals.isEmpty || groomingGoals.isEmpty {
                return "Choose at least one goal in each category."
            }
        case .bodyComposition:
            if !measurementFeetOptions.contains(neckFeet) || !measurementInchOptions.contains(neckInches) {
                return "Choose a neck measurement."
            }
            if !measurementFeetOptions.contains(waistFeet) || !measurementInchOptions.contains(waistInches) {
                return "Choose a waist measurement."
            }
            if gender == "Female" && (!measurementFeetOptions.contains(hipFeet) || !measurementInchOptions.contains(hipInches)) {
                return "Choose a hip measurement."
            }
            guard let neckTotalInches = totalInches(feet: neckFeet, inches: neckInches),
                  let waistTotalInches = totalInches(feet: waistFeet, inches: waistInches) else {
                return "Enter valid neck and waist measurements."
            }
            if waistTotalInches <= neckTotalInches {
                return "Waist should be larger than neck for a valid estimate."
            }
            if gender == "Female" {
                guard let hipTotalInches = totalInches(feet: hipFeet, inches: hipInches) else {
                    return "Enter a valid hip measurement."
                }
                if (waistTotalInches + hipTotalInches) <= neckTotalInches {
                    return "Hip and waist measurements need to produce a valid estimate."
                }
            }
        case .lifestyle:
            if !sleepOptions.contains(sleepHours) { return "Choose daily sleep." }
            guard let ounces = Double(hydrationOunces), ounces >= 0, ounces <= 500 else { return "Enter hydration from 0 to 500 oz." }
            if !hasAtMostOneDecimal(hydrationOunces) { return "Hydration should use at most one decimal place." }
            if !exerciseDayOptions.contains(exerciseDays) { return "Choose exercise days per week." }
            if dietQuality.isEmpty { return "Select diet quality." }
            guard let calories = Int(calorieIntake), calories >= 0, calories <= 10000 else { return "Enter calories from 0 to 10000." }
            if dietNotes.trimmingCharacters(in: .whitespacesAndNewlines).count < 8 { return "Add a quick note about what the user usually eats." }
        case .review:
            return nil
        }

        return nil
    }

    private func goBack() {
        guard let previous = OnboardingStep(rawValue: selectedStep.rawValue - 1) else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            selectedStep = previous
        }
    }

    private func goForward() async {
        guard validationMessage == nil else { return }

        if selectedStep == .review {
            let didSave = await appModel.saveProfile(
                input: ProfileInput(
                    age: age,
                    gender: gender,
                    heightFeet: heightFeet,
                    heightInches: heightInches,
                    weightPounds: weightPounds,
                    neckFeet: neckFeet,
                    neckInches: neckInches,
                    waistFeet: waistFeet,
                    waistInches: waistInches,
                    hipFeet: hipFeet,
                    hipInches: hipInches,
                    skinGoals: Array(skinGoals).sorted(),
                    hairGoals: Array(hairGoals).sorted(),
                    bodyGoals: Array(bodyGoals).sorted(),
                    groomingGoals: Array(groomingGoals).sorted(),
                    sleepHours: sleepHours,
                    hydrationOunces: hydrationOunces,
                    exerciseDays: exerciseDays,
                    dietQuality: dietQuality,
                    dietNotes: dietNotes,
                    calorieIntake: calorieIntake
                )
            )
            if didSave && mode == .editing {
                dismiss()
            }
            return
        }

        guard let next = OnboardingStep(rawValue: selectedStep.rawValue + 1) else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            selectedStep = next
        }
    }

    private func applyDevDataForCurrentStep() {
        switch selectedStep {
        case .profile:
            fillDevProfile()
        case .goals:
            fillDevGoals()
        case .bodyComposition:
            fillDevBody()
        case .lifestyle:
            fillDevLifestyle()
        case .review:
            fillDevProfile()
            fillDevGoals()
            fillDevBody()
            fillDevLifestyle()
        }
    }

    private func stepIntro(for step: OnboardingStep) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(step.title)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.foreground)
            Text(step.subtitle)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bodyMeasurementReviewLines: [String] {
        var lines = [
            "Neck: \(neckFeet) ft \(neckInches) in",
            "Waist: \(waistFeet) ft \(waistInches) in"
        ]

        if gender == "Female" {
            lines.append("Hip: \(hipFeet) ft \(hipInches) in")
        }

        if let estimate = estimatedBodyFatDisplay {
            lines.append("Estimated body fat: \(estimate)")
        }

        return lines
    }

    private func decimalField(title: String, text: Binding<String>, keyboard: UIKeyboardType, placeholder: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
            TextField(placeholder ?? title, text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .luxuryInput()
        }
    }

    private func measurementGroup(title: String, feet: Binding<String>, inches: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
            HStack(spacing: 12) {
                menuField(title: "Feet", selection: feet, options: measurementFeetOptions, placeholder: "0", compactLabel: true)
                menuField(title: "Inches", selection: inches, options: measurementInchOptions, placeholder: "0", compactLabel: true)
            }
        }
    }

    private func wholeNumberField(title: String, text: Binding<String>, keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
            TextField(title, text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .luxuryInput()
        }
    }

    private func multilineField(title: String, text: Binding<String>, prompt: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppTheme.surfaceInset)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(AppTheme.border, lineWidth: 1)
                    )
                if text.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(prompt)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }
                TextEditor(text: text)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 104)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .foregroundStyle(AppTheme.foreground)
            }
            .frame(minHeight: 104)
        }
    }

    private func menuField(title: String, selection: Binding<String>, options: [String], placeholder: String, compactLabel: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(compactLabel ? .caption.weight(.semibold) : .subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection.wrappedValue = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.wrappedValue.isEmpty ? placeholder : selection.wrappedValue)
                        .foregroundStyle(selection.wrappedValue.isEmpty ? AppTheme.muted : AppTheme.foreground)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(AppTheme.muted)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .insetSurface()
        }
    }

    private func goalSection(title: String, options: [String], selection: Binding<Set<String>>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.foreground)

            ForEach(options, id: \.self) { option in
                Button {
                    toggle(option, in: selection)
                } label: {
                    HStack {
                        Text(option)
                            .foregroundStyle(AppTheme.foreground)
                        Spacer()
                        Image(systemName: selection.wrappedValue.contains(option) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(selection.wrappedValue.contains(option) ? AppTheme.primary : AppTheme.muted)
                    }
                    .padding(14)
                    .insetSurface()
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .glassCard()
    }

    private func reviewCard(title: String, lines: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.foreground)
            ForEach(lines, id: \.self) { line in
                Text(line)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .insetSurface()
            }
        }
        .padding(20)
        .glassCard()
    }

    private func joinedGoals(from goals: Set<String>) -> String {
        goals.sorted().joined(separator: ", ")
    }

    private func toggle(_ option: String, in selection: Binding<Set<String>>) {
        if selection.wrappedValue.contains(option) {
            selection.wrappedValue.remove(option)
        } else {
            selection.wrappedValue.insert(option)
        }
    }

    private func hasAtMostOneDecimal(_ value: String) -> Bool {
        guard let decimalIndex = value.firstIndex(of: ".") else { return true }
        let decimalPlaces = value.distance(from: decimalIndex, to: value.endIndex) - 1
        return decimalPlaces <= 1
    }

    private var estimatedBodyFatDisplay: String? {
        let hipCentimeters = gender == "Female"
            ? ProfileService.lengthCM(feetString: hipFeet, inchesString: hipInches)
            : nil
        guard let estimate = ProfileService.bodyFatEstimate(
            gender: gender,
            heightCM: ProfileService.heightCM(feetString: heightFeet, inchesString: heightInches),
            neckCM: ProfileService.lengthCM(feetString: neckFeet, inchesString: neckInches),
            waistCM: ProfileService.lengthCM(feetString: waistFeet, inchesString: waistInches),
            hipCM: hipCentimeters
        ) else {
            return nil
        }

        if let category = ProfileService.bodyFatCategory(gender: gender, estimate: estimate) {
            return String(format: "%.1f%% (%@)", estimate, category)
        }

        return String(format: "%.1f%%", estimate)
    }

    private func totalInches(feet: String, inches: String) -> Double? {
        guard let feetValue = Double(feet), let inchesValue = Double(inches) else { return nil }
        return (feetValue * 12) + inchesValue
    }

    private func fillDevProfile() {
        let ageValues = ["18", "21", "24", "27", "31"]
        let genderValues = ["Male", "Female"]
        let heightPairs = [("5", "8.0"), ("5", "10.0"), ("6", "0.0"), ("6", "1.0")]
        let weightValues = ["152.0", "168.5", "181.0", "194.5", "208.0"]

        age = ageValues.randomElement() ?? "24"
        gender = genderValues.randomElement() ?? "Male"
        let height = heightPairs.randomElement() ?? ("5", "10.0")
        heightFeet = height.0
        heightInches = height.1
        weightPounds = weightValues.randomElement() ?? "181.0"
    }

    private func fillDevGoals() {
        skinGoals = randomGoalSelection(from: skinGoalOptions, count: 2)
        hairGoals = randomGoalSelection(from: hairGoalOptions, count: 2)
        bodyGoals = randomGoalSelection(from: bodyGoalOptions, count: 2)
        groomingGoals = randomGoalSelection(from: groomingGoalOptions, count: 2)
    }

    private func fillDevBody() {
        if age.isEmpty || gender.isEmpty || heightFeet.isEmpty || heightInches.isEmpty {
            fillDevProfile()
        }

        if gender == "Female" {
            let femaleTriples = [
                (("1", "2.5"), ("2", "10.0"), ("3", "6.0")),
                (("1", "3.0"), ("2", "8.0"), ("3", "8.0")),
                (("1", "2.0"), ("2", "9.5"), ("3", "7.0"))
            ]
            let sample = femaleTriples.randomElement() ?? (("1", "2.5"), ("2", "10.0"), ("3", "6.0"))
            neckFeet = sample.0.0
            neckInches = sample.0.1
            waistFeet = sample.1.0
            waistInches = sample.1.1
            hipFeet = sample.2.0
            hipInches = sample.2.1
        } else {
            let malePairs = [
                (("1", "3.0"), ("2", "10.0")),
                (("1", "4.0"), ("3", "0.0")),
                (("1", "2.5"), ("2", "8.5"))
            ]
            let sample = malePairs.randomElement() ?? (("1", "3.0"), ("2", "10.0"))
            neckFeet = sample.0.0
            neckInches = sample.0.1
            waistFeet = sample.1.0
            waistInches = sample.1.1
            hipFeet = "0"
            hipInches = "0.0"
        }
    }

    private func fillDevLifestyle() {
        let sleepValues = ["6", "7", "8", "9"]
        let hydrationValues = ["72.0", "88.0", "96.0", "110.0"]
        let exerciseValues = ["2", "3", "4", "5"]
        let dietValues = ["Fair", "Decent", "Good", "Strong"]
        let dietNoteValues = [
            "Eggs and coffee in the morning, chicken bowl for lunch, steak and rice for dinner.",
            "Protein shake after lifting, takeout twice a week, yogurt and fruit for breakfast.",
            "Oatmeal in the morning, sandwich for lunch, salmon with rice at night.",
            "Usually coffee first, quick lunch, chicken and potatoes for dinner, snacks at night."
        ]
        let calorieValues = ["2200", "2450", "2700", "2950"]

        sleepHours = sleepValues.randomElement() ?? "8"
        hydrationOunces = hydrationValues.randomElement() ?? "96.0"
        exerciseDays = exerciseValues.randomElement() ?? "4"
        dietQuality = dietValues.randomElement() ?? "Decent"
        dietNotes = dietNoteValues.randomElement() ?? "Eggs, chicken, rice, and a couple takeout meals each week."
        calorieIntake = calorieValues.randomElement() ?? "2450"
    }

    private func randomGoalSelection(from options: [String], count: Int) -> Set<String> {
        Set(options.shuffled().prefix(max(1, min(count, options.count))))
    }
}
