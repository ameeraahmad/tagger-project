import { drizzle } from "drizzle-orm/d1-http";
import * as schema from "./schema";

const accountId = process.env.CLOUDFLARE_ACCOUNT_ID;
const databaseId = process.env.CLOUDFLARE_DATABASE_ID || "0db95838-6916-4566-b59f-50dd89c6a892";
const token = process.env.CLOUDFLARE_D1_TOKEN;

if (!accountId || !token) {
  console.warn("⚠️ Warning: CLOUDFLARE_ACCOUNT_ID or CLOUDFLARE_D1_TOKEN is missing in environment variables. Database queries may fail.");
}

// Initialize Drizzle ORM with Cloudflare D1 HTTP driver (perfect for Vercel)
export const db = drizzle({
  accountId: accountId,
  databaseId: databaseId,
  token: token,
}, { schema });
