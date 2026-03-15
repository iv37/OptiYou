"use server";

import { uploadSchema } from "@/lib/validations";

export async function saveUploadSetAction(_: unknown, formData: FormData) {
  const parsed = uploadSchema.safeParse({
    frontFace: formData.get("frontFace"),
    sideFace: formData.get("sideFace"),
    skinCloseup: formData.get("skinCloseup"),
    hairline: formData.get("hairline")
  });

  if (!parsed.success) {
    return {
      success: false,
      errors: parsed.error.flatten().fieldErrors
    };
  }

  return {
    success: true
  };
}
