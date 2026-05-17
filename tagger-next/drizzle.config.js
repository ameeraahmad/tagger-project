import { defineConfig } from "drizzle-kit";

export default defineConfig({
  schema: "./db/schema.js",
  out: "./migrations",
  dialect: "sqlite",
  dbCredentials: {
    url: "../database.sqlite",
  },
});
