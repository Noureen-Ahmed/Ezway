/**
 * Check for recent unread notifications
 * This helps identify if there are any unread notifications that should be showing
 */

const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

async function checkRecentUnreadNotifications() {
  try {
    console.log('=== Checking for Recent Unread Notifications ===\n');

    // 1. Get all unread notifications
    const unreadNotifications = await p.notification.findMany({
      where: {
        isRead: false
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            name: true,
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    console.log(`Total unread notifications: ${unreadNotifications.length}\n`);

    if (unreadNotifications.length > 0) {
      console.log('Unread notifications:');
      unreadNotifications.forEach((n, index) => {
        console.log(`  ${index + 1}. User: ${n.user.email} (${n.user.id})`);
        console.log(`     Title: ${n.title}`);
        console.log(`     Type: ${n.type}`);
        console.log(`     Created: ${n.createdAt.toISOString()}`);
        console.log(`     Reference: ${n.referenceType} - ${n.referenceId}`);
        console.log('');
      });
    } else {
      console.log('No unread notifications found in the database.\n');
    }

    // 2. Get all notifications created in the last hour
    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
    const recentNotifications = await p.notification.findMany({
      where: {
        createdAt: {
          gte: oneHourAgo
        }
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            name: true,
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    console.log(`\n=== Notifications created in the last hour ===`);
    console.log(`Total recent notifications: ${recentNotifications.length}\n`);

    if (recentNotifications.length > 0) {
      console.log('Recent notifications:');
      recentNotifications.forEach((n, index) => {
        console.log(`  ${index + 1}. User: ${n.user.email} (${n.user.id})`);
        console.log(`     Title: ${n.title}`);
        console.log(`     Type: ${n.type}`);
        console.log(`     Read: ${n.isRead ? 'YES' : 'NO'}`);
        console.log(`     Created: ${n.createdAt.toISOString()}`);
        console.log(`     Reference: ${n.referenceType} - ${n.referenceId}`);
        console.log('');
      });
    } else {
      console.log('No notifications created in the last hour.\n');
    }

    // 3. Get the most recent notification for each user
    console.log(`\n=== Most recent notification for each user ===`);
    const users = await p.user.findMany({
      select: {
        id: true,
        email: true,
        name: true,
      }
    });

    for (const user of users) {
      const mostRecent = await p.notification.findFirst({
        where: { userId: user.id },
        orderBy: { createdAt: 'desc' }
      });

      if (mostRecent) {
        const minutesAgo = Math.floor((Date.now() - mostRecent.createdAt.getTime()) / 60000);
        console.log(`  ${user.email}:`);
        console.log(`    Most recent: ${mostRecent.title}`);
        console.log(`    Created: ${minutesAgo} minutes ago`);
        console.log(`    Read: ${mostRecent.isRead ? 'YES' : 'NO'}`);
        console.log('');
      }
    }

  } catch (error) {
    console.error('Error checking recent unread notifications:', error);
  } finally {
    await p.$disconnect();
  }
}

checkRecentUnreadNotifications();