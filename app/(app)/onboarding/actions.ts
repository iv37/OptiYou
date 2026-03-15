"use server";

import { onboardingSchema } from "@/lib/validations";

export async function saveOnboardingAction(_: unknown, formData: FormData) {
  const parsed = onboardingSchema.safeParse({
    age: formData.get("age"),
    gender: formData.get("gender"),
    heightCm: formData.get("heightCm"),
    weightKg: formData.get("weightKg"),
    goals: formData.getAll("goals"),
    skinType: formData.get("skinType"),
    skinConcerns: formData.get("skinConcerns"),
    hairThickness: formData.get("hairThickness"),
    hairLength: formData.get("hairLength"),
    hairConcerns: formData.get("hairConcerns"),
    sleepHours: formData.get("sleepHours"),
    hydrationLiters: formData.get("hydrationLiters"),
    exerciseDays: formData.get("exerciseDays"),
    dietQuality: formData.get("dietQuality"),
    calorieIntake: formData.get("calorieIntake")
  });

  if (!parsed.success) {
    return {
      success: false,
      errors: parsed.error.flatten().fieldErrors
    };
  }

  return {
    success: true,
    data: parsed.data
  };
}
