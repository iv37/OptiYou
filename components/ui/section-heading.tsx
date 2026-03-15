import { Badge } from "@/components/ui/badge";

export function SectionHeading({
  eyebrow,
  title,
  description
}: {
  eyebrow?: string;
  title: string;
  description: string;
}) {
  return (
    <div className="space-y-3">
      {eyebrow ? <Badge>{eyebrow}</Badge> : null}
      <div className="space-y-2">
        <h2 className="text-2xl font-semibold tracking-tight sm:text-3xl">{title}</h2>
        <p className="max-w-2xl text-sm leading-6 text-muted sm:text-base">{description}</p>
      </div>
    </div>
  );
}
