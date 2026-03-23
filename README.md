# AI Personal Aesthetic Optimization App

## 1. Product assumptions
- The product is a supportive optimization platform, not a face-rating product.
- Supabase Auth and Storage are the intended production integrations, with demo adapters in place for local development.
- Body composition outputs are calculated. Lifestyle, skincare, hair, and facial modules combine rule-based heuristics with simulated AI phrasing.
- Recommendations stay informational and non-medical.
- Premium is gated in schema and UI, but billing is intentionally deferred.

## 2. Architecture overview
- Frontend: Next.js App Router with mobile-first route groups for marketing, auth, and signed-in app areas.
- Backend shape: server-side services in `lib/services`, Prisma schema for PostgreSQL, and server-action scaffolding for onboarding and uploads.
- Data layer: Prisma models for users, profile, goals, media, analyses, recommendations, progress, and premium access.
- Integration layer: Supabase-ready auth and storage adapters in `lib/supabase` and `lib/services/storage-service.ts`.
- Visualization: Recharts for progress trends.

## 3. Tech stack justification
- Next.js App Router: route-level loading/error states, server components, and Vercel-ready deployment.
- TypeScript: strict domain typing across UI, services, and schema contracts.
- Tailwind CSS v4: fast design system iteration with a calm, premium visual language.
- Reusable component approach: lightweight shadcn-style primitives without overbuilding.
- Prisma + PostgreSQL: scalable relational modeling for progress history and analysis runs.
- Supabase Auth/Storage: practical startup default for auth, uploads, and row-level security expansion.

## 4. Folder structure
```text
app/
  (app)/dashboard
  (app)/onboarding
  (app)/upload
  (app)/analysis/*
  (app)/progress
  (app)/recommendations
  (app)/settings
  (app)/premium
  auth/sign-in
  auth/sign-up
components/
  analysis/
  dashboard/
  layout/
  progress/
  recommendations/
  ui/
lib/
  constants/
  data/
  services/
  supabase/
prisma/
styles/
types/
```

## 5. Database schema
- `User`: app account and auth mapping.
- `Profile`: onboarding answers and lifestyle context.
- `Goal` / `UserGoal`: reusable goal taxonomy and selections.
- `UploadedMedia`: photo assets by capture type.
- `AnalysisResult`: structured module outputs with confidence classification.
- `Recommendation`: dated roadmap payloads.
- `ProgressEntry`: time-series metrics for trend tracking.
- `PremiumAccess`: plan tier, status, and feature flags.

Full schema: [`prisma/schema.prisma`](/Users/ivan/Documents/Playground 3/prisma/schema.prisma)

## 6. Route map
- `/`: landing page
- `/auth/sign-in`
- `/auth/sign-up`
- `/onboarding`
- `/onboarding/goals`
- `/onboarding/profile`
- `/dashboard`
- `/upload`
- `/processing`
- `/analysis/facial`
- `/analysis/skincare`
- `/analysis/hair`
- `/analysis/body`
- `/analysis/lifestyle`
- `/progress`
- `/recommendations`
- `/settings`
- `/premium`

## 7. Component inventory
- Layout: `AppShell`, `MarketingShell`
- UI primitives: `Button`, `Card`, `Badge`, `Input`, `Textarea`, `Progress`, `SectionHeading`
- Dashboard: `MetricCard`, `ModuleCard`
- Analysis: `AnalysisDetail`
- Recommendations: `RoadmapCard`
- Progress: `ProgressChart`

## 8. Design system rules
- Warm neutral surfaces, restrained green primary, muted gold accent.
- Rounded containers with glassmorphism-lite treatment and clear spacing.
- One dominant CTA per screen with secondary actions visually subordinate.
- Supportive, concise copy that avoids appearance-shaming language.
- Strong empty/loading/error affordances are built into route structure.

## 9. Build phases
- Phase 1: repo setup, configs, design tokens, UI primitives, shell layouts
- Phase 2: auth-ready screens, onboarding routes, profile data contracts
- Phase 3: upload flow, processing state, dashboard
- Phase 4: analysis modules
- Phase 5: recommendation roadmap
- Phase 6: progress tracking
- Phase 7: premium gating structure
- Phase 8: polish, safe copy, loading/error states
- Phase 9: final run-through and handoff notes

## Running locally
1. Install dependencies: `npm install`
2. Copy envs: `cp .env.example .env.local`
3. Generate Prisma client: `npm run prisma:generate`
4. Run migrations: `npm run prisma:migrate`
5. Seed goals: `npm run prisma:seed`
6. Start dev server: `npm run dev`

## Current mocked vs real
- Real architecture: routes, schema, typed services, premium gating structure, progress charting, validation contracts.
- Mocked or simulated: auth session wiring, signed upload flow, persistent DB reads/writes, CV/ML analysis inference, billing.

## Native auth setup
- The native iPhone app now includes Supabase-backed signup/login, Keychain session storage, multi-step onboarding, and protected routes in `ios/AestheticOptimization`.
- Auth screens live in [AuthView.swift](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization/Views/Auth/AuthView.swift).
- Root route protection lives in [RootContainerView.swift](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization/Views/RootContainerView.swift).
- Session logic lives in [AuthService.swift](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization/Services/AuthService.swift) and [KeychainHelper.swift](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization/Services/KeychainHelper.swift).
- Profile persistence lives in [ProfileService.swift](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization/Services/ProfileService.swift).
- Native onboarding flow lives in [ProfileSetupView.swift](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization/Views/Profile/ProfileSetupView.swift).
- Database schema is in [schema.sql](/Users/ivan/Documents/Playground 3/supabase/schema.sql).

## Native run steps
1. Create a Supabase project.
2. In the Supabase SQL editor, run [schema.sql](/Users/ivan/Documents/Playground 3/supabase/schema.sql).
3. Open [Info.plist](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization/Info.plist) and set:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Open [AestheticOptimization.xcodeproj](/Users/ivan/Documents/Playground 3/ios/AestheticOptimization/AestheticOptimization.xcodeproj) in Xcode.
5. Run the `AestheticOptimization` scheme on an iPhone simulator.

## Example current user fetch
- After login, the app restores the stored session from Keychain and calls Supabase `GET /auth/v1/user`.
- The fetched current user email is shown in Settings as the working example of authenticated user retrieval.

## Native onboarding flow
- Steps: `profile`, `goals`, `lifestyle`, `review`
- UX: swipeable `TabView`, progress indicator, back/next buttons, validation on every step
- Persistence: saves the completed onboarding payload into `profiles`
- Gating: the dashboard is not accessible until `onboarding_completed = true`
