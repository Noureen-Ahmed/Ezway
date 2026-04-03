const { execSync } = require('child_process');
try {
  execSync('npx prisma generate', { stdio: 'pipe' });
} catch(e) {
  const std = e.stderr.toString() + "\n" + e.stdout.toString();
  require('fs').writeFileSync('prisma_pure.txt', std.replace(/\u001b\[\d+m/g, ''));
}
