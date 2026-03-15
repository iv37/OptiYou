import { z } from "zod";

export const onboardingSchema = z.object({
  age: z.coerce.number().min(16).max(80),
  gender: z.string().min(1),
  heightCm: z.coerce.number().min(130).max(230),
  weightKg: z.coerce.number().min(35).max(220),
  goals: z.array(z.string()).min(1),
  skinType: z.string().min(1),
  skinConcerns: z.string().optional(),
  hairThickness: z.string().min(1),
  hairLength: z.string().min(1),
  hairConcerns: z.string().optional(),
  sleepHours: z.coerce.number().min(4).max(12),
  hydrationLiters: z.coerce.number().min(0.5).max(7),
  exerciseDays: z.coerce.number().min(0).max(7),
  dietQuality: z.string().min(1),
  calorieIntake: z.coerce.number().min(1000).max(6000).optional()
});

export const uploadSchema = z.object({
  frontFace: z.string().min(1),
  sideFace: z.string().min(1),
  skinCloseup: z.string().min(1),
  hairline: z.string().min(1)
});
