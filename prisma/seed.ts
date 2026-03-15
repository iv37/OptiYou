import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const goals = [
    ["clearer_skin", "Clearer skin", "Reduce congestion and improve skin calmness."],
    ["hair_health", "Hair health", "Improve density presentation and scalp care."],
    ["leaner_face", "Leaner face", "Reduce puffiness through lifestyle habits."],
    ["body_recomposition", "Body recomposition", "Build a more athletic look sustainably."],
    ["stronger_grooming", "Grooming", "Improve haircut, facial hair, and skin presentation."],
    ["consistency", "Consistency", "Build routines that stick."]
  ] as const;

  for (const [key, label, description] of goals) {
    await prisma.goal.upsert({
      where: { key },
      update: { label, description },
      create: { key, label, description }
    });
  }
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
