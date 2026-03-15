import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Aesthetic Optimization App",
    short_name: "Aesthetic OS",
    description: "An iPhone-first progress platform for skincare, grooming, body composition, and lifestyle optimization.",
    start_url: "/dashboard",
    display: "standalone",
    background_color: "#f5f1ea",
    theme_color: "#f5f1ea",
    orientation: "portrait",
    icons: [
      {
        src: "/icon-192.svg",
        sizes: "192x192",
        type: "image/svg+xml"
      },
      {
        src: "/icon-512.svg",
        sizes: "512x512",
        type: "image/svg+xml"
      }
    ]
  };
}
