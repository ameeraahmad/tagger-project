CREATE TABLE `Ads` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer,
	`title` text NOT NULL,
	`description` text,
	`price` real,
	`currency` text DEFAULT 'USD',
	`category` text,
	`subCategory` text,
	`country` text,
	`city` text,
	`targetCountries` text,
	`images` text,
	`status` text DEFAULT 'pending',
	`isVip` integer DEFAULT false,
	`isGlobal` integer DEFAULT false,
	`views` integer DEFAULT 0,
	`expiresAt` text,
	`rejectionReason` text,
	`createdAt` text DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` text DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `BlogPosts` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`title` text NOT NULL,
	`slug` text,
	`content` text,
	`excerpt` text,
	`image` text,
	`authorId` integer,
	`status` text DEFAULT 'draft',
	`createdAt` text DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` text DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`authorId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `BlogPosts_slug_unique` ON `BlogPosts` (`slug`);--> statement-breakpoint
CREATE TABLE `Favorites` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer,
	`adId` integer,
	`createdAt` text DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`adId`) REFERENCES `Ads`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `Messages` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`senderId` integer,
	`receiverId` integer,
	`adId` integer,
	`content` text NOT NULL,
	`isRead` integer DEFAULT false,
	`createdAt` text DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`senderId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`receiverId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`adId`) REFERENCES `Ads`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `Notifications` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer,
	`type` text,
	`message` text,
	`isRead` integer DEFAULT false,
	`link` text,
	`createdAt` text DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `Users` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`password` text,
	`phone` text,
	`country` text,
	`city` text,
	`avatar` text,
	`role` text DEFAULT 'user',
	`isVerified` integer DEFAULT false,
	`provider` text DEFAULT 'local',
	`providerId` text,
	`plan` text DEFAULT 'free',
	`planExpiresAt` text,
	`adsLimit` integer DEFAULT 5,
	`resetToken` text,
	`resetTokenExpires` text,
	`loginAttempts` integer DEFAULT 0,
	`lockUntil` text,
	`createdAt` text DEFAULT CURRENT_TIMESTAMP,
	`updatedAt` text DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
CREATE UNIQUE INDEX `Users_email_unique` ON `Users` (`email`);