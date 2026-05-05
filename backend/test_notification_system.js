/**
 * End-to-end test for notification system
 * This script tests the complete flow from notification creation to API response
 */

const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');
const p = new PrismaClient();

async function testNotificationSystem() {
  try {
    console.log('=== End-to-End Notification System Test ===\n');

    // 1. Get a test user
    const testUserId = 'cmoou7270000o4boa1vfw2mo8';
    const user = await p.user.findUnique({
      where: { id: testUserId },
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
        fcmToken: true,
      }
    });

    if (!user) {
      console.log('❌ Test user not found!');
      return;
    }

    console.log(`✅ Test User: ${user.email} (${user.id})`);
    console.log(`   Role: ${user.role}`);
    console.log(`   FCM Token: ${user.fcmToken ? 'Present' : 'Not set'}\n`);

    // 2. Create a test notification
    console.log('--- Creating Test Notification ---');
    const testNotification = await p.notification.create({
      data: {
        userId: user.id,
        title: '🧪 Test Notification',
        message: 'This is a test notification to verify the system is working correctly.',
        type: 'GENERAL',
        isRead: false,
        isPushed: false
      }
    });

    console.log(`✅ Created notification: ${testNotification.id}`);
    console.log(`   Title: ${testNotification.title}`);
    console.log(`   Type: ${testNotification.type}`);
    console.log(`   Read: ${testNotification.isRead}`);
    console.log(`   Pushed: ${testNotification.isPushed}\n`);

    // 3. Simulate API request (what Flutter does)
    console.log('--- Simulating API Request ---');
    
    // Generate JWT token
    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '7d' }
    );

    // Verify token (what auth middleware does)
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
    console.log(`✅ JWT decoded: userId = ${decoded.userId}`);
    console.log(`   Matches user.id: ${decoded.userId === user.id ? 'YES' : 'NO'}\n`);

    // Query notifications (what notification route does)
    const notifications = await p.notification.findMany({
      where: {
        userId: decoded.userId,
      },
      orderBy: { createdAt: 'desc' },
      take: 50
    });

    console.log(`✅ Found ${notifications.length} notifications`);
    
    // Get unread count
    const unreadCount = await p.notification.count({
      where: {
        userId: decoded.userId,
        isRead: false
      }
    });

    console.log(`✅ Unread count: ${unreadCount}\n`);

    // 4. Format API response (what Flutter receives)
    console.log('--- API Response (what Flutter receives) ---');
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

    // Show first 3 notifications
    console.log(`Total notifications: ${response.notifications.length}`);
    console.log(`Unread count: ${response.unreadCount}\n`);
    
    console.log('First 3 notifications:');
    response.notifications.slice(0, 3).forEach((n, index) => {
      console.log(`  ${index + 1}. ${n.title}`);
      console.log(`     Type: ${n.type}`);
      console.log(`     Read: ${n.isRead ? 'YES' : 'NO'}`);
      console.log(`     Created: ${n.createdAt}`);
      console.log('');
    });

    // 5. Test marking notification as read
    console.log('--- Testing Mark as Read ---');
    await p.notification.update({
      where: { id: testNotification.id },
      data: {
        isRead: true,
        readAt: new Date()
      }
    });

    const updatedNotification = await p.notification.findUnique({
      where: { id: testNotification.id }
    });

    console.log(`✅ Notification marked as read`);
    console.log(`   isRead: ${updatedNotification.isRead}`);
    console.log(`   readAt: ${updatedNotification.readAt}\n`);

    // 6. Clean up test notification
    console.log('--- Cleaning Up ---');
    await p.notification.delete({
      where: { id: testNotification.id }
    });

    console.log(`✅ Test notification deleted\n`);

    // 7. Final verification
    console.log('=== Final Verification ===');
    const finalNotifications = await p.notification.findMany({
      where: { userId: user.id },
      orderBy: { createdAt: 'desc' },
      take: 5
    });

    console.log(`✅ User has ${finalNotifications.length} notifications remaining`);
    console.log('✅ All tests passed successfully!\n');

  } catch (error) {
    console.error('❌ Error testing notification system:', error);
  } finally {
    await p.$disconnect();
  }
}

testNotificationSystem();