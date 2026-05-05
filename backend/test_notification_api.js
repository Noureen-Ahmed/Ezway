/**
 * Test script to verify notification API is working correctly
 * This simulates what the Flutter app does when fetching notifications
 */

const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');
const p = new PrismaClient();

async function testNotificationAPI() {
  try {
    console.log('=== Testing Notification API ===\n');

    // 1. Get a test user (the one from check_noureen_notifs.js)
    const testUserId = 'cmoou7270000o4boa1vfw2mo8';
    const user = await p.user.findUnique({
      where: { id: testUserId },
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
      }
    });

    if (!user) {
      console.log('User not found!');
      return;
    }

    console.log(`Test User: ${user.email} (${user.id})\n`);

    // 2. Generate a JWT token (simulating what the backend does)
    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '7d' }
    );

    console.log(`Generated JWT token (first 50 chars): ${token.substring(0, 50)}...\n`);

    // 3. Verify the token (simulating what the auth middleware does)
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
    console.log(`Decoded token userId: ${decoded.userId}`);
    console.log(`Matches user.id: ${decoded.userId === user.id ? 'YES' : 'NO'}\n`);

    // 4. Query notifications (simulating what the notification route does)
    const notifications = await p.notification.findMany({
      where: {
        userId: decoded.userId,
      },
      orderBy: { createdAt: 'desc' },
      take: 50
    });

    console.log(`Found ${notifications.length} notifications for userId: ${decoded.userId}\n`);

    if (notifications.length > 0) {
      console.log('Notifications:');
      notifications.forEach((n, index) => {
        console.log(`  ${index + 1}. ${n.title}`);
        console.log(`     Type: ${n.type}`);
        console.log(`     Read: ${n.isRead}`);
        console.log(`     Created: ${n.createdAt.toISOString()}`);
        console.log(`     Reference: ${n.referenceType} - ${n.referenceId}`);
        console.log('');
      });
    }

    // 5. Get unread count
    const unreadCount = await p.notification.count({
      where: {
        userId: decoded.userId,
        isRead: false
      }
    });

    console.log(`Unread count: ${unreadCount}\n`);

    // 6. Format the response (simulating what the notification route does)
    const response = {
      success: true,
      notifications: notifications.map(n => ({
        id: n.id,
        title: n.title,
        message: n.message,
        type: n.type,
        referenceType: n.referenceType,
        referenceId: n.referenceId,
        isRead: n.isRead,
        createdAt: n.createdAt,
        readAt: n.readAt
      })),
      unreadCount
    };

    console.log('=== API Response (what Flutter would receive) ===');
    console.log(JSON.stringify(response, null, 2));

  } catch (error) {
    console.error('Error testing notification API:', error);
  } finally {
    await p.$disconnect();
  }
}

testNotificationAPI();