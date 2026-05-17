import { sqliteTable, uniqueIndex, integer, text, numeric, real } from "drizzle-orm/sqlite-core"
import { sql } from "drizzle-orm"

export const users = sqliteTable("Users", {
	id: integer().primaryKey(),
	name: text({ length: 255 }).notNull(),
	email: text({ length: 255 }).notNull(),
	password: text({ length: 255 }).notNull(),
	phone: text({ length: 255 }),
	role: text().default("user"),
	avatar: text({ length: 255 }).default("https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y"),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	bio: text(),
	location: text({ length: 255 }),
	isOnline: integer().default(0),
	lastActive: numeric(),
	emailNotifications: integer().default(1),
	chatNotifications: integer().default(1),
	isEmailVerified: integer().default(0),
	emailVerificationToken: text({ length: 255 }),
	passwordResetToken: text({ length: 255 }),
	passwordResetExpires: numeric(),
	isBanned: integer().default(0),
	country: text({ length: 255 }).default("uae"),
	passwordChangedAt: numeric(),
	loginAttempts: integer().default(0),
	lockUntil: numeric(),
	resetOtp: text({ length: 255 }),
	resetOtpExpires: numeric(),
},
(table) => [
	uniqueIndex("users_email_country").on(table.email, table.country),
]);

export const favorites = sqliteTable("Favorites", {
	id: integer().primaryKey(),
	userId: integer().notNull().references(() => users.id),
	adId: integer().notNull().references(() => ads.id),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
});

export const messages = sqliteTable("Messages", {
	id: integer().primaryKey(),
	name: text({ length: 255 }).notNull(),
	email: text({ length: 255 }).notNull(),
	subject: text({ length: 255 }),
	message: text().notNull(),
	isRead: integer().default(0),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
});

export const conversations = sqliteTable("Conversations", {
	id: integer().primaryKey({ autoIncrement: true }),
	buyerId: integer().notNull().references(() => users.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	sellerId: integer().notNull().references(() => users.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	adId: integer().notNull().references(() => ads.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	deletedByBuyer: integer().default(0),
	deletedBySeller: integer().default(0),
});

export const chatMessages = sqliteTable("ChatMessages", {
	id: integer().primaryKey({ autoIncrement: true }),
	conversationId: integer().notNull().references(() => conversations.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	senderId: integer().notNull().references(() => users.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	message: text().notNull(),
	isRead: integer().default(0),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	image: text({ length: 255 }),
});

export const ads = sqliteTable("Ads", {
	id: integer().primaryKey(),
	title: text({ length: 255 }).notNull(),
	description: text().notNull(),
	price: real().notNull(),
	category: text().notNull(),
	subCategory: text({ length: 255 }),
	city: text({ length: 255 }).notNull(),
	area: text({ length: 255 }),
	images: text().default("[\"https://via.placeholder.com/600x400?text=No+Image\"]"),
	status: text().default("active"),
	userId: integer().references(() => users.id),
	views: integer().default(0),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	year: integer(),
	kilometers: integer(),
	itemCondition: text({ length: 255 }),
	phone: text({ length: 255 }),
	isFeatured: integer().default(0),
	featuredUntil: numeric(),
	rejectionReason: text(),
	country: text({ length: 255 }).default("uae"),
	bedrooms: integer(),
	bathrooms: integer(),
	propertyType: text({ length: 255 }),
	editCount: integer().default(0),
	lastEditedAt: numeric(),
	latitude: real(),
	longitude: real(),
	paymentMethod: text({ length: 255 }),
	completionStatus: text({ length: 255 }),
	furnished: text({ length: 255 }),
	amenities: text().default("[]"),
});

export const usersBackup = sqliteTable("Users_backup", {
	id: integer().primaryKey(),
	name: text({ length: 255 }).notNull(),
	email: text({ length: 255 }).notNull(),
	password: text({ length: 255 }).notNull(),
	phone: text({ length: 255 }),
	role: text().default("user"),
	avatar: text({ length: 255 }).default("https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y"),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	bio: text(),
	location: text({ length: 255 }),
});

export const reviews = sqliteTable("Reviews", {
	id: integer().primaryKey({ autoIncrement: true }),
	reviewerId: integer().notNull().references(() => users.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	sellerId: integer().notNull().references(() => users.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	adId: integer().references(() => ads.id, { onDelete: "set null", onUpdate: "cascade" } ),
	rating: integer().notNull(),
	comment: text(),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
});

export const reports = sqliteTable("Reports", {
	id: integer().primaryKey({ autoIncrement: true }),
	adId: integer().notNull().references(() => ads.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	reporterId: integer().notNull().references(() => users.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	reason: text({ length: 255 }).notNull(),
	description: text(),
	status: text().default("pending"),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
});

export const notifications = sqliteTable("Notifications", {
	id: integer().primaryKey({ autoIncrement: true }),
	userId: integer().notNull().references(() => users.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	type: text().notNull(),
	title: text({ length: 255 }).notNull(),
	message: text().notNull(),
	link: text({ length: 255 }),
	isRead: integer().default(0),
	relatedId: integer(),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
});

export const payments = sqliteTable("Payments", {
	id: integer().primaryKey({ autoIncrement: true }),
	userId: integer().notNull(),
	adId: integer(),
	stripeSessionId: text({ length: 255 }),
	stripePaymentIntentId: text({ length: 255 }),
	amount: real().notNull(),
	currency: text({ length: 255 }).default("usd"),
	plan: text().notNull(),
	status: text().default("pending"),
	durationDays: integer().default(30),
	metadata: text().default("{}"),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
});

export const newsletterSubscribers = sqliteTable("newsletter_subscribers", {
	id: integer().primaryKey({ autoIncrement: true }),
	email: text({ length: 255 }).notNull(),
	name: text({ length: 255 }),
	isActive: integer().default(1),
	unsubscribeToken: text({ length: 255 }).notNull(),
	subscribedAt: numeric(),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	country: text({ length: 255 }).default("uae"),
});

export const supportRequests = sqliteTable("support_requests", {
	id: integer().primaryKey({ autoIncrement: true }),
	name: text({ length: 255 }).notNull(),
	email: text({ length: 255 }).notNull(),
	subject: text({ length: 255 }).notNull(),
	message: text().notNull(),
	status: text().default("pending"),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	isRead: integer().default(0),
	isReplied: integer().default(0),
	replyMessage: text(),
	phone: text({ length: 255 }),
	isImportant: integer().default(0),
	country: text({ length: 255 }).default("uae"),
});

export const supportMessages = sqliteTable("support_messages", {
	id: integer().primaryKey({ autoIncrement: true }),
	requestId: integer().notNull().references(() => supportRequests.id, { onDelete: "cascade", onUpdate: "cascade" } ),
	senderId: integer().references(() => users.id, { onDelete: "set null", onUpdate: "cascade" } ),
	senderName: text({ length: 255 }).notNull(),
	message: text().notNull(),
	isAdmin: integer().default(0),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
});

export const blogPosts = sqliteTable("blog_posts", {
	id: integer().primaryKey(),
	titleEn: text("title_en", { length: 255 }).notNull(),
	titleAr: text("title_ar", { length: 255 }).notNull(),
	slug: text({ length: 255 }),
	excerptEn: text("excerpt_en").notNull(),
	excerptAr: text("excerpt_ar").notNull(),
	contentEn: text("content_en").notNull(),
	contentAr: text("content_ar").notNull(),
	category: text().default("tips"),
	featuredImage: text({ length: 255 }).default("assets/images/placeholder-blog.jpg"),
	status: text().default("published"),
	views: integer().default(0),
	authorId: integer().references(() => users.id),
	createdAt: numeric().notNull(),
	updatedAt: numeric().notNull(),
	isImportant: integer().default(0),
	country: text({ length: 255 }).default("uae"),
});
