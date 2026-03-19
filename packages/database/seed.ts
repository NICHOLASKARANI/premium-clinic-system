import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');
  
  // Create tenant
  const tenant = await prisma.tenant.create({
    data: {
      name: 'Main Clinic',
      subdomain: 'main',
      settings: {
        timezone: 'UTC',
        currency: 'USD'
      }
    }
  });
  console.log('✓ Tenant created');
  
  // Create admin user
  const hashedPassword = await bcrypt.hash('admin123', 10);
  const admin = await prisma.user.create({
    data: {
      email: 'admin@clinic.com',
      password: hashedPassword,
      firstName: 'Super',
      lastName: 'Admin',
      role: 'SUPER_ADMIN',
      phone: '+1234567890',
      tenantId: tenant.id
    }
  });
  console.log('✓ Admin user created');
  
  // Create sample patient
  await prisma.patient.create({
    data: {
      patientId: 'P-2024-00001',
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: new Date('1990-01-01'),
      gender: 'MALE',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      tenantId: tenant.id,
      primaryDoctorId: admin.id
    }
  });
  console.log('✓ Sample patient created');
  
  console.log('✅ Seeding complete!');
}

main()
  .catch((e) => {
    console.error('❌ Seeding failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });