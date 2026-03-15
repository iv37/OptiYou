import { isDemoMode } from "@/lib/env";

export interface UploadedFileResult {
  path: string;
  publicUrl: string;
  provider: "demo" | "supabase";
}

export async function uploadAsset(fileName: string): Promise<UploadedFileResult> {
  if (isDemoMode) {
    return {
      path: `demo/${fileName}`,
      publicUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=900&q=80",
      provider: "demo"
    };
  }

  throw new Error("Supabase storage adapter is not configured yet.");
}
