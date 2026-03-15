"use client";

import { Area, AreaChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

import type { ProgressPoint } from "@/types/domain";

export function ProgressChart({ data }: { data: ProgressPoint[] }) {
  return (
    <div className="h-72 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <AreaChart data={data}>
          <defs>
            <linearGradient id="skin" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#1d4d43" stopOpacity={0.35} />
              <stop offset="95%" stopColor="#1d4d43" stopOpacity={0.02} />
            </linearGradient>
          </defs>
          <CartesianGrid stroke="rgba(73, 62, 47, 0.1)" vertical={false} />
          <XAxis dataKey="date" tickLine={false} axisLine={false} tick={{ fill: "#6f675d", fontSize: 12 }} />
          <YAxis tickLine={false} axisLine={false} tick={{ fill: "#6f675d", fontSize: 12 }} />
          <Tooltip
            contentStyle={{
              borderRadius: 16,
              border: "1px solid rgba(73, 62, 47, 0.12)",
              background: "rgba(255,255,255,0.92)"
            }}
          />
          <Area type="monotone" dataKey="skinClarity" stroke="#1d4d43" fill="url(#skin)" strokeWidth={2.5} />
          <Area type="monotone" dataKey="groomingConsistency" stroke="#c6a56d" fillOpacity={0} strokeWidth={2.5} />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
