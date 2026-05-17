import { db } from "@/db";
import { users } from "@/db/schema";
import { NextResponse } from "next/server";

export async function GET() {
  try {
    // Fetch users count to test D1 connection via HTTP
    const allUsers = await db.select().from(users).all();
    
    return NextResponse.json({
      success: true,
      message: "Successfully connected to Cloudflare D1 from Next.js (Vercel Ready!)",
      totalUsers: allUsers.length,
      users: allUsers.map(u => ({ id: u.id, name: u.name, email: u.email, role: u.role }))
    });
  } catch (error) {
    return NextResponse.json({
      success: false,
      error: error.message,
      hint: "Make sure you have set CLOUDFLARE_ACCOUNT_ID and CLOUDFLARE_D1_TOKEN in your env variables."
    }, { status: 500 });
  }
}
