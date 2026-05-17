CREATE TABLE `Ads` (
	`id` integer PRIMARY KEY NOT NULL,
	`title` text(255) NOT NULL,
	`description` text NOT NULL,
	`price` real NOT NULL,
	`category` text NOT NULL,
	`subCategory` text(255),
	`city` text(255) NOT NULL,
	`area` text(255),
	`images` text DEFAULT '["https://via.placeholder.com/600x400?text=No+Image"]',
	`status` text DEFAULT 'active',
	`userId` integer,
	`views` integer DEFAULT 0,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`year` integer,
	`kilometers` integer,
	`itemCondition` text(255),
	`phone` text(255),
	`isFeatured` integer DEFAULT 0,
	`featuredUntil` numeric,
	`rejectionReason` text,
	`country` text(255) DEFAULT 'uae',
	`bedrooms` integer,
	`bathrooms` integer,
	`propertyType` text(255),
	`editCount` integer DEFAULT 0,
	`lastEditedAt` numeric,
	`latitude` real,
	`longitude` real,
	`paymentMethod` text(255),
	`completionStatus` text(255),
	`furnished` text(255),
	`amenities` text DEFAULT '[]',
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `blog_posts` (
	`id` integer PRIMARY KEY NOT NULL,
	`title_en` text(255) NOT NULL,
	`title_ar` text(255) NOT NULL,
	`slug` text(255),
	`excerpt_en` text NOT NULL,
	`excerpt_ar` text NOT NULL,
	`content_en` text NOT NULL,
	`content_ar` text NOT NULL,
	`category` text DEFAULT 'tips',
	`featuredImage` text(255) DEFAULT 'assets/images/placeholder-blog.jpg',
	`status` text DEFAULT 'published',
	`views` integer DEFAULT 0,
	`authorId` integer,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`isImportant` integer DEFAULT 0,
	`country` text(255) DEFAULT 'uae',
	FOREIGN KEY (`authorId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `ChatMessages` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`conversationId` integer NOT NULL,
	`senderId` integer NOT NULL,
	`message` text NOT NULL,
	`isRead` integer DEFAULT 0,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`image` text(255),
	FOREIGN KEY (`conversationId`) REFERENCES `Conversations`(`id`) ON UPDATE cascade ON DELETE cascade,
	FOREIGN KEY (`senderId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `Conversations` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`buyerId` integer NOT NULL,
	`sellerId` integer NOT NULL,
	`adId` integer NOT NULL,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`deletedByBuyer` integer DEFAULT 0,
	`deletedBySeller` integer DEFAULT 0,
	FOREIGN KEY (`buyerId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE cascade,
	FOREIGN KEY (`sellerId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE cascade,
	FOREIGN KEY (`adId`) REFERENCES `Ads`(`id`) ON UPDATE cascade ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `Favorites` (
	`id` integer PRIMARY KEY NOT NULL,
	`userId` integer NOT NULL,
	`adId` integer NOT NULL,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`adId`) REFERENCES `Ads`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `Messages` (
	`id` integer PRIMARY KEY NOT NULL,
	`name` text(255) NOT NULL,
	`email` text(255) NOT NULL,
	`subject` text(255),
	`message` text NOT NULL,
	`isRead` integer DEFAULT 0,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL
);
--> statement-breakpoint
CREATE TABLE `newsletter_subscribers` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`email` text(255) NOT NULL,
	`name` text(255),
	`isActive` integer DEFAULT 1,
	`unsubscribeToken` text(255) NOT NULL,
	`subscribedAt` numeric,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`country` text(255) DEFAULT 'uae'
);
--> statement-breakpoint
CREATE TABLE `Notifications` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer NOT NULL,
	`type` text NOT NULL,
	`title` text(255) NOT NULL,
	`message` text NOT NULL,
	`link` text(255),
	`isRead` integer DEFAULT 0,
	`relatedId` integer,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `Payments` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer NOT NULL,
	`adId` integer,
	`stripeSessionId` text(255),
	`stripePaymentIntentId` text(255),
	`amount` real NOT NULL,
	`currency` text(255) DEFAULT 'usd',
	`plan` text NOT NULL,
	`status` text DEFAULT 'pending',
	`durationDays` integer DEFAULT 30,
	`metadata` text DEFAULT '{}',
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL
);
--> statement-breakpoint
CREATE TABLE `Reports` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`adId` integer NOT NULL,
	`reporterId` integer NOT NULL,
	`reason` text(255) NOT NULL,
	`description` text,
	`status` text DEFAULT 'pending',
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	FOREIGN KEY (`adId`) REFERENCES `Ads`(`id`) ON UPDATE cascade ON DELETE cascade,
	FOREIGN KEY (`reporterId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `Reviews` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`reviewerId` integer NOT NULL,
	`sellerId` integer NOT NULL,
	`adId` integer,
	`rating` integer NOT NULL,
	`comment` text,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	FOREIGN KEY (`reviewerId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE cascade,
	FOREIGN KEY (`sellerId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE cascade,
	FOREIGN KEY (`adId`) REFERENCES `Ads`(`id`) ON UPDATE cascade ON DELETE set null
);
--> statement-breakpoint
CREATE TABLE `support_messages` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`requestId` integer NOT NULL,
	`senderId` integer,
	`senderName` text(255) NOT NULL,
	`message` text NOT NULL,
	`isAdmin` integer DEFAULT 0,
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	FOREIGN KEY (`requestId`) REFERENCES `support_requests`(`id`) ON UPDATE cascade ON DELETE cascade,
	FOREIGN KEY (`senderId`) REFERENCES `Users`(`id`) ON UPDATE cascade ON DELETE set null
);
--> statement-breakpoint
CREATE TABLE `support_requests` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text(255) NOT NULL,
	`email` text(255) NOT NULL,
	`subject` text(255) NOT NULL,
	`message` text NOT NULL,
	`status` text DEFAULT 'pending',
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`isRead` integer DEFAULT 0,
	`isReplied` integer DEFAULT 0,
	`replyMessage` text,
	`phone` text(255),
	`isImportant` integer DEFAULT 0,
	`country` text(255) DEFAULT 'uae'
);
--> statement-breakpoint
CREATE TABLE `Users` (
	`id` integer PRIMARY KEY NOT NULL,
	`name` text(255) NOT NULL,
	`email` text(255) NOT NULL,
	`password` text(255) NOT NULL,
	`phone` text(255),
	`role` text DEFAULT 'user',
	`avatar` text(255) DEFAULT 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`bio` text,
	`location` text(255),
	`isOnline` integer DEFAULT 0,
	`lastActive` numeric,
	`emailNotifications` integer DEFAULT 1,
	`chatNotifications` integer DEFAULT 1,
	`isEmailVerified` integer DEFAULT 0,
	`emailVerificationToken` text(255),
	`passwordResetToken` text(255),
	`passwordResetExpires` numeric,
	`isBanned` integer DEFAULT 0,
	`country` text(255) DEFAULT 'uae',
	`passwordChangedAt` numeric,
	`loginAttempts` integer DEFAULT 0,
	`lockUntil` numeric,
	`resetOtp` text(255),
	`resetOtpExpires` numeric
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_country` ON `Users` (`email`,`country`);--> statement-breakpoint
CREATE TABLE `Users_backup` (
	`id` integer PRIMARY KEY NOT NULL,
	`name` text(255) NOT NULL,
	`email` text(255) NOT NULL,
	`password` text(255) NOT NULL,
	`phone` text(255),
	`role` text DEFAULT 'user',
	`avatar` text(255) DEFAULT 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
	`createdAt` numeric NOT NULL,
	`updatedAt` numeric NOT NULL,
	`bio` text,
	`location` text(255)
);
