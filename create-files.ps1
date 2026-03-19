# create-files.ps1
Write-Host "Creating Premium Clinic System files..." -ForegroundColor Green

# Function to create file with content
function Create-File {
    param($Path, $Content)
    $fullPath = Join-Path $PSScriptRoot $Path
    $directory = Split-Path $fullPath -Parent
    if (!(Test-Path $directory)) {
        New-Item -ItemType Directory -Force -Path $directory | Out-Null
    }
    Set-Content -Path $fullPath -Value $Content -Force
    Write-Host "Created: $Path" -ForegroundColor Yellow
}

# Root package.json
Create-File "package.json" @'
{
  "name": "premium-clinic-system",
  "version": "1.0.0",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "start": "turbo start",
    "lint": "turbo lint",
    "test": "turbo test",
    "db:migrate": "cd packages/database && prisma migrate deploy",
    "db:generate": "cd packages/database && prisma generate",
    "db:seed": "cd packages/database && tsx seed.ts"
  },
  "devDependencies": {
    "turbo": "^1.10.16",
    "prettier": "^3.0.3",
    "typescript": "^5.2.2"
  },
  "engines": {
    "node": ">=18.0.0"
  },
  "packageManager": "npm@9.0.0"
}
'@

# turbo.json
Create-File "turbo.json" @'
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "test": {
      "dependsOn": ["build"],
      "inputs": ["src/**/*.tsx", "src/**/*.ts", "test/**/*.ts"]
    }
  }
}
'@

# docker-compose.yml
Create-File "docker-compose.yml" @'
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: clinic-postgres
    environment:
      POSTGRES_DB: clinic_db
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secure_password_123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - clinic-network

  redis:
    image: redis:7-alpine
    container_name: clinic-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - clinic-network

  elasticsearch:
    image: elasticsearch:8.10.0
    container_name: clinic-elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - clinic-network

  minio:
    image: minio/minio:latest
    container_name: clinic-minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin123
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data
    networks:
      - clinic-network

networks:
  clinic-network:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
  elasticsearch_data:
  minio_data:
'@

# .env.example
Create-File ".env.example" @'
# App
NODE_ENV=development
PORT=3000
API_URL=http://localhost:4000
NEXT_PUBLIC_API_URL=http://localhost:4000

# Database
DATABASE_URL="postgresql://admin:secure_password_123@localhost:5432/clinic_db?schema=public"

# Redis
REDIS_URL="redis://localhost:6379"

# JWT
JWT_SECRET="your-super-secret-jwt-key-change-in-production"
JWT_EXPIRES_IN="7d"
REFRESH_TOKEN_SECRET="your-refresh-token-secret"
REFRESH_TOKEN_EXPIRES_IN="30d"

# AWS
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=us-east-1
AWS_S3_BUCKET=clinic-documents

# Stripe
STRIPE_SECRET_KEY=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=

# Twilio
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_PHONE_NUMBER=

# SendGrid
SENDGRID_API_KEY=
FROM_EMAIL=noreply@clinic.com
'@

# .gitignore
Create-File ".gitignore" @'
# dependencies
node_modules
.pnp
.pnp.js
.yarn/install-state.gz

# testing
coverage

# next.js
.next/
out/
build
dist

# production
apps/web/.next
apps/web/out
apps/api/dist

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# local env files
.env
.env*.local
.env.development.local
.env.test.local
.env.production.local

# vercel
.vercel

# turbo
.turbo

# prisma
packages/database/prisma/*.db
packages/database/prisma/*.db-journal
'@

# README.md
Create-File "README.md" @'
# Premium Clinic Management System

Advanced clinic management solution with multi-tenancy, EMR/EHR, appointment scheduling, billing, and more.

## Features

- 🏥 Patient Management
- 📅 Appointment Scheduling
- 📋 Electronic Medical Records (EMR)
- 💰 Billing & Payments
- 📦 Inventory Management
- 🔬 Laboratory Integration
- 💊 Pharmacy Module
- 📱 Communication Hub
- 📊 Reporting & Analytics
- 🔒 HIPAA Compliant

## Tech Stack

- **Frontend**: Next.js 14, TypeScript, Tailwind CSS
- **Backend**: NestJS, GraphQL, Prisma
- **Database**: PostgreSQL, Redis
- **Infrastructure**: Docker, AWS, Vercel

## Getting Started

1. Clone the repository
2. Install dependencies: `npm install`
3. Copy .env.example to .env
4. Start Docker: `docker-compose up -d`
5. Run migrations: `npm run db:migrate`
6. Generate Prisma client: `npm run db:generate`
7. Seed database: `npm run db:seed`
8. Start development: `npm run dev`

## Deployment

- Frontend: Vercel
- Backend: AWS ECS
- Database: AWS RDS
'@

# Database package.json
Create-File "packages/database/package.json" @'
{
  "name": "@clinic/database",
  "version": "1.0.0",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch",
    "db:generate": "prisma generate",
    "db:push": "prisma db push --skip-generate",
    "db:migrate": "prisma migrate dev",
    "db:reset": "prisma migrate reset",
    "db:seed": "tsx seed.ts",
    "db:studio": "prisma studio"
  },
  "dependencies": {
    "@prisma/client": "^5.3.1",
    "bcryptjs": "^2.4.3"
  },
  "devDependencies": {
    "prisma": "^5.3.1",
    "tsup": "^7.2.0",
    "tsx": "^3.13.0",
    "typescript": "^5.2.2",
    "@faker-js/faker": "^8.0.2"
  }
}
'@

# Prisma schema
Create-File "packages/database/prisma/schema.prisma" @'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum UserRole {
  SUPER_ADMIN
  ADMIN
  DOCTOR
  NURSE
  RECEPTIONIST
  LAB_TECHNICIAN
  PHARMACIST
  PATIENT
}

enum AppointmentStatus {
  SCHEDULED
  CONFIRMED
  IN_PROGRESS
  COMPLETED
  CANCELLED
  NO_SHOW
  RESCHEDULED
}

enum Gender {
  MALE
  FEMALE
  OTHER
}

model Tenant {
  id        String   @id @default(cuid())
  name      String   @unique
  subdomain String   @unique
  settings  Json     @default("{}")
  isActive  Boolean  @default(true)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  users         User[]
  patients      Patient[]
  appointments  Appointment[]
  invoices      Invoice[]
  inventory     InventoryItem[]
  labOrders     LabOrder[]
  auditLogs     AuditLog[]
}

model User {
  id            String    @id @default(cuid())
  email         String    @unique
  password      String
  firstName     String
  lastName      String
  role          UserRole
  phone         String?
  avatar        String?
  emailVerified Boolean   @default(false)
  isActive      Boolean   @default(true)
  lastLogin     DateTime?
  mfaSecret     String?
  mfaEnabled    Boolean   @default(false)
  tenantId      String
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  tenant          Tenant           @relation(fields: [tenantId], references: [id])
  appointments    Appointment[]    @relation("doctor")
  patients        Patient[]        @relation("primaryDoctor")
  medicalRecords  MedicalRecord[]  @relation("createdBy")
  prescriptions   Prescription[]   @relation("prescribedBy")
  auditLogs       AuditLog[]       @relation("user")
  notifications   Notification[]   @relation("recipient")
  messages        Message[]        @relation("sender")
  receivedMessages Message[]        @relation("recipient")

  @@unique([tenantId, email])
}

model Patient {
  id              String          @id @default(cuid())
  patientId       String          @unique
  firstName       String
  lastName        String
  dateOfBirth     DateTime
  gender          Gender
  email           String?
  phone           String
  address         String?
  city            String?
  state           String?
  zipCode         String?
  country         String?         @default("US")
  emergencyContact Json?
  insuranceInfo   Json?
  medicalHistory  Json?
  allergies       Json?
  bloodType       String?
  maritalStatus   String?
  occupation      String?
  profilePhoto    String?
  qrCode          String?
  tenantId        String
  primaryDoctorId String?
  isActive        Boolean         @default(true)
  createdAt       DateTime        @default(now())
  updatedAt       DateTime        @updatedAt

  tenant          Tenant           @relation(fields: [tenantId], references: [id])
  primaryDoctor   User?            @relation("primaryDoctor", fields: [primaryDoctorId], references: [id])
  appointments    Appointment[]
  medicalRecords  MedicalRecord[]
  prescriptions   Prescription[]
  labOrders       LabOrder[]
  invoices        Invoice[]
  documents       Document[]
  familyMembers   FamilyLink[]     @relation("guardian")
  guardians       FamilyLink[]     @relation("patient")
}

model Appointment {
  id              String            @id @default(cuid())
  appointmentNumber String          @unique
  patientId       String
  doctorId        String
  tenantId        String
  startTime       DateTime
  endTime         DateTime
  status          AppointmentStatus @default(SCHEDULED)
  type            String
  reason          String?
  notes           String?
  roomId          String?
  isTelehealth    Boolean           @default(false)
  telehealthUrl   String?
  recurrenceRule  Json?
  cancelledAt     DateTime?
  cancellationReason String?
  noShowAt        DateTime?
  completedAt     DateTime?
  createdById     String
  createdAt       DateTime          @default(now())
  updatedAt       DateTime          @updatedAt

  patient  Patient @relation(fields: [patientId], references: [id])
  doctor   User    @relation("doctor", fields: [doctorId], references: [id])
  tenant   Tenant  @relation(fields: [tenantId], references: [id])
  createdBy User   @relation(fields: [createdById], references: [id])
  reminders AppointmentReminder[]
  vitals    VitalSign[]
}

model MedicalRecord {
  id            String   @id @default(cuid())
  patientId     String
  doctorId      String
  tenantId      String
  recordType    String
  title         String
  content       Json?
  templateId    String?
  isConfidential Boolean  @default(false)
  signedBy      String?
  signedAt      DateTime?
  attachments   Json?
  metadata      Json?    @default("{}")
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt

  patient Patient @relation(fields: [patientId], references: [id])
  doctor  User    @relation("createdBy", fields: [doctorId], references: [id])
  tenant  Tenant  @relation(fields: [tenantId], references: [id])
}

model Invoice {
  id              String        @id @default(cuid())
  invoiceNumber   String        @unique
  patientId       String
  tenantId        String
  appointmentId   String?
  issueDate       DateTime      @default(now())
  dueDate         DateTime
  status          String @default("PENDING")
  subtotal        Float
  tax             Float         @default(0)
  discount        Float         @default(0)
  total           Float
  paidAmount      Float         @default(0)
  balance         Float
  paymentMethod   String?
  insuranceClaim  Json?
  notes           String?
  metadata        Json?         @default("{}")
  createdAt       DateTime      @default(now())
  updatedAt       DateTime      @updatedAt

  patient     Patient      @relation(fields: [patientId], references: [id])
  tenant      Tenant       @relation(fields: [tenantId], references: [id])
  appointment Appointment? @relation(fields: [appointmentId], references: [id])
  items       InvoiceItem[]
  payments    Payment[]
}

model InvoiceItem {
  id          String   @id @default(cuid())
  invoiceId   String
  description String
  quantity    Int
  unitPrice   Float
  amount      Float
  type        String
  referenceId String?
  createdAt   DateTime @default(now())

  invoice Invoice @relation(fields: [invoiceId], references: [id])
}

model Payment {
  id          String   @id @default(cuid())
  invoiceId   String
  amount      Float
  method      String
  reference   String?
  status      String   @default("COMPLETED")
  receivedBy  String
  notes       String?
  createdAt   DateTime @default(now())

  invoice    Invoice @relation(fields: [invoiceId], references: [id])
  receivedByUser User  @relation(fields: [receivedBy], references: [id])
}

model InventoryItem {
  id              String   @id @default(cuid())
  sku             String   @unique
  name            String
  description     String?
  category        String
  quantity        Int      @default(0)
  unit            String
  reorderLevel    Int
  reorderQuantity Int
  costPrice       Float
  sellingPrice    Float
  manufacturer    String?
  supplier        String?
  location        String?
  expiryDate      DateTime?
  batchNumber     String?
  isActive        Boolean  @default(true)
  tenantId        String
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt

  tenant     Tenant        @relation(fields: [tenantId], references: [id])
  movements  InventoryMovement[]
}

model InventoryMovement {
  id          String   @id @default(cuid())
  itemId      String
  type        String
  quantity    Int
  previousQty Int
  newQty      Int
  reference   String?
  reason      String?
  performedBy String
  notes       String?
  createdAt   DateTime @default(now())

  item       InventoryItem @relation(fields: [itemId], references: [id])
  performedByUser User      @relation(fields: [performedBy], references: [id])
}

model LabOrder {
  id              String    @id @default(cuid())
  orderNumber     String    @unique
  patientId       String
  doctorId        String
  tenantId        String
  labTests        Json
  status          String
  priority        String    @default("ROUTINE")
  collectionDate  DateTime?
  collectionNotes String?
  resultDate      DateTime?
  results         Json?
  resultFile      String?
  isAbnormal      Boolean?
  notes           String?
  createdAt       DateTime  @default(now())
  updatedAt       DateTime  @updatedAt

  patient Patient @relation(fields: [patientId], references: [id])
  doctor  User    @relation(fields: [doctorId], references: [id])
  tenant  Tenant  @relation(fields: [tenantId], references: [id])
}

model Document {
  id          String   @id @default(cuid())
  patientId   String
  uploadedById String
  tenantId    String
  name        String
  type        String
  category    String?
  fileUrl     String
  fileSize    Int
  mimeType    String
  description String?
  isConfidential Boolean @default(false)
  metadata    Json?    @default("{}")
  uploadedAt  DateTime @default(now())
  updatedAt   DateTime @updatedAt

  patient    Patient @relation(fields: [patientId], references: [id])
  uploadedBy User    @relation(fields: [uploadedById], references: [id])
  tenant     Tenant  @relation(fields: [tenantId], references: [id])
}

model Message {
  id          String   @id @default(cuid())
  senderId    String
  recipientId String
  tenantId    String
  subject     String?
  content     String
  attachments Json?
  isRead      Boolean  @default(false)
  readAt      DateTime?
  isUrgent    Boolean  @default(false)
  parentId    String?
  createdAt   DateTime @default(now())

  sender    User    @relation("sender", fields: [senderId], references: [id])
  recipient User    @relation("recipient", fields: [recipientId], references: [id])
  tenant    Tenant  @relation(fields: [tenantId], references: [id])
  parent    Message? @relation("replies", fields: [parentId], references: [id])
  replies   Message[] @relation("replies")
}

model Notification {
  id          String   @id @default(cuid())
  userId      String
  type        String
  title       String
  content     String
  data        Json?
  isRead      Boolean  @default(false)
  readAt      DateTime?
  createdAt   DateTime @default(now())

  user User @relation("recipient", fields: [userId], references: [id])
}

model AuditLog {
  id          String   @id @default(cuid())
  userId      String?
  tenantId    String
  action      String
  entity      String
  entityId    String?
  oldValue    Json?
  newValue    Json?
  ipAddress   String?
  userAgent   String?
  createdAt   DateTime @default(now())

  user   User?   @relation("user", fields: [userId], references: [id])
  tenant Tenant @relation(fields: [tenantId], references: [id])
}

model AppointmentReminder {
  id            String   @id @default(cuid())
  appointmentId String
  type          String
  scheduledFor  DateTime
  sentAt        DateTime?
  status        String
  createdAt     DateTime @default(now())

  appointment Appointment @relation(fields: [appointmentId], references: [id])
}

model VitalSign {
  id            String   @id @default(cuid())
  patientId     String
  appointmentId String?
  recordedById  String
  bloodPressureSystolic Int?
  bloodPressureDiastolic Int?
  heartRate     Int?
  temperature   Float?
  respiratoryRate Int?
  oxygenSaturation Int?
  height        Float?
  weight        Float?
  bmi           Float?
  painLevel     Int?
  notes         String?
  recordedAt    DateTime @default(now())

  patient     Patient     @relation(fields: [patientId], references: [id])
  appointment Appointment? @relation(fields: [appointmentId], references: [id])
  recordedBy  User        @relation(fields: [recordedById], references: [id])
}

model FamilyLink {
  id          String   @id @default(cuid())
  patientId   String
  guardianId  String
  relation    String
  isPrimary   Boolean  @default(false)
  createdAt   DateTime @default(now())

  patient  Patient @relation("patient", fields: [patientId], references: [id])
  guardian Patient @relation("guardian", fields: [guardianId], references: [id])

  @@unique([patientId, guardianId])
}

model Prescription {
  id              String     @id @default(cuid())
  prescriptionNumber String   @unique
  patientId       String
  doctorId        String
  tenantId        String
  medication      String
  dosage          String
  frequency       String
  route           String?
  duration        String?
  quantity        Int
  refills         Int        @default(0)
  instructions    String?
  status          String @default("ACTIVE")
  isControlled    Boolean    @default(false)
  deaNumber       String?
  dispensedById   String?
  dispensedAt     DateTime?
  expiresAt       DateTime?
  createdAt       DateTime   @default(now())
  updatedAt       DateTime   @updatedAt

  patient    Patient    @relation(fields: [patientId], references: [id])
  doctor     User       @relation("prescribedBy", fields: [doctorId], references: [id])
  tenant     Tenant     @relation(fields: [tenantId], references: [id])
  dispensedBy User?     @relation("dispensedBy", fields: [dispensedById], references: [id])
}

model Setting {
  id          String   @id @default(cuid())
  key         String
  value       Json
  description String?
  category    String
  isPublic    Boolean  @default(false)
  tenantId    String?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  tenant Tenant? @relation(fields: [tenantId], references: [id])

  @@unique([key, tenantId])
}
'@

# Database seed file
Create-File "packages/database/seed.ts" @'
import { PrismaClient } from '@prisma/client'
import { hash } from 'bcryptjs'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Seeding database...')

  const tenant = await prisma.tenant.create({
    data: {
      name: 'Main Clinic',
      subdomain: 'main',
      settings: {
        timezone: 'America/New_York',
        currency: 'USD',
        dateFormat: 'MM/DD/YYYY',
      },
    },
  })

  const hashedPassword = await hash('Admin123!', 12)
  const admin = await prisma.user.create({
    data: {
      email: 'admin@clinic.com',
      password: hashedPassword,
      firstName: 'Super',
      lastName: 'Admin',
      role: 'SUPER_ADMIN',
      phone: '+1234567890',
      tenantId: tenant.id,
      emailVerified: true,
    },
  })

  console.log('✅ Seeding completed!')
}

main()
  .catch((e) => {
    console.error('❌ Seeding failed:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
'@

# Database index.ts
Create-File "packages/database/src/index.ts" @'
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma

export * from '@prisma/client'
'@

# Database tsup config
Create-File "packages/database/tsup.config.ts" @'
import { defineConfig } from 'tsup'

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  clean: true,
})
'@

# Database tsconfig.json
Create-File "packages/database/tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
'@

# Web app package.json
Create-File "apps/web/package.json" @'
{
  "name": "web",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@clinic/database": "*",
    "@clinic/ui": "*",
    "@hookform/resolvers": "^3.3.0",
    "@radix-ui/react-accordion": "^1.1.2",
    "@radix-ui/react-alert-dialog": "^1.0.5",
    "@radix-ui/react-avatar": "^1.0.4",
    "@radix-ui/react-checkbox": "^1.0.4",
    "@radix-ui/react-dialog": "^1.0.5",
    "@radix-ui/react-dropdown-menu": "^2.0.6",
    "@radix-ui/react-label": "^2.0.2",
    "@radix-ui/react-popover": "^1.0.7",
    "@radix-ui/react-select": "^2.0.0",
    "@radix-ui/react-separator": "^1.0.3",
    "@radix-ui/react-slot": "^1.0.2",
    "@radix-ui/react-switch": "^1.0.3",
    "@radix-ui/react-tabs": "^1.0.4",
    "@radix-ui/react-toast": "^1.1.5",
    "@radix-ui/react-tooltip": "^1.0.7",
    "@tanstack/react-query": "^4.35.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "date-fns": "^2.30.0",
    "lucide-react": "^0.279.0",
    "next-auth": "^4.23.0",
    "next-themes": "^0.2.1",
    "react-hook-form": "^7.46.0",
    "react-hot-toast": "^2.4.1",
    "sonner": "^0.2.0",
    "tailwind-merge": "^1.14.0",
    "tailwindcss-animate": "^1.0.7",
    "zod": "^3.22.0"
  },
  "devDependencies": {
    "@types/node": "^20.3.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "autoprefixer": "^10.4.14",
    "eslint": "^8.42.0",
    "eslint-config-next": "14.0.0",
    "postcss": "^8.4.27",
    "tailwindcss": "^3.3.3",
    "typescript": "^5.2.2"
  }
}
'@

# Web app layout.tsx
Create-File "apps/web/app/layout.tsx" @'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Premium Clinic Management System',
  description: 'Advanced clinic management solution',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
'@

# Web app globals.css
Create-File "apps/web/app/globals.css" @'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 212.7 26.8% 83.9%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
'@

# Web app tailwind config
Create-File "apps/web/tailwind.config.js" @'
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
}
'@

# Web app next config
Create-File "apps/web/next.config.js" @'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = nextConfig
'@

# Web app tsconfig.json
Create-File "apps/web/tsconfig.json" @'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
'@

# Web app login page
Create-File "apps/web/app/(auth)/login/page.tsx" @'
export default function LoginPage() {
  return (
    <div className="container flex h-screen w-screen flex-col items-center justify-center">
      <div className="mx-auto flex w-full flex-col justify-center space-y-6 sm:w-[350px]">
        <div className="flex flex-col space-y-2 text-center">
          <h1 className="text-2xl font-semibold tracking-tight">
            Welcome back
          </h1>
          <p className="text-sm text-muted-foreground">
            Enter your email to sign in to your account
          </p>
        </div>
      </div>
    </div>
  )
}
'@

# API package.json
Create-File "apps/api/package.json" @'
{
  "name": "api",
  "version": "1.0.0",
  "scripts": {
    "dev": "nest start --watch",
    "build": "nest build",
    "start": "nest start",
    "start:prod": "node dist/main",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\""
  },
  "dependencies": {
    "@clinic/database": "*",
    "@nestjs/common": "^10.0.0",
    "@nestjs/config": "^3.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/graphql": "^12.0.0",
    "@nestjs/jwt": "^10.0.0",
    "@nestjs/passport": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/throttler": "^5.0.0",
    "@prisma/client": "^5.3.1",
    "apollo-server-express": "^3.12.0",
    "bcryptjs": "^2.4.3",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.0",
    "graphql": "^16.8.0",
    "helmet": "^7.0.0",
    "ioredis": "^5.3.0",
    "joi": "^17.9.0",
    "jsonwebtoken": "^9.0.0",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.0",
    "passport-local": "^1.0.35",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.8.0"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/bcryptjs": "^2.4.2",
    "@types/express": "^4.17.17",
    "@types/jest": "^29.5.0",
    "@types/node": "^20.3.0",
    "@types/passport-jwt": "^3.0.8",
    "@types/passport-local": "^1.0.35",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.42.0",
    "jest": "^29.5.0",
    "ts-jest": "^29.1.0",
    "ts-loader": "^9.4.3",
    "ts-node": "^10.9.1",
    "tsconfig-paths": "^4.2.0",
    "typescript": "^5.1.3"
  }
}
'@

# API main.ts
Create-File "apps/api/src/main.ts" @'
import { NestFactory } from '@nestjs/core'
import { ValidationPipe } from '@nestjs/common'
import * as helmet from 'helmet'
import { AppModule } from './app.module'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)
  
  app.use(helmet())
  app.enableCors()
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }))
  
  await app.listen(4000)
  console.log(`Application is running on: http://localhost:4000`)
}
bootstrap()
'@

# API app.module.ts
Create-File "apps/api/src/app.module.ts" @'
import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { GraphQLModule } from '@nestjs/graphql'
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo'
import { ThrottlerModule } from '@nestjs/throttler'
import { AuthModule } from './auth/auth.module'
import { PatientsModule } from './patients/patients.module'
import { PrismaModule } from './prisma/prisma.module'

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: true,
      playground: true,
    }),
    ThrottlerModule.forRoot({
      ttl: 60,
      limit: 100,
    }),
    PrismaModule,
    AuthModule,
    PatientsModule,
  ],
})
export class AppModule {}
'@

# Prisma module
Create-File "apps/api/src/prisma/prisma.module.ts" @'
import { Module, Global } from '@nestjs/common'
import { PrismaService } from './prisma.service'

@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
'@

# Prisma service
Create-File "apps/api/src/prisma/prisma.service.ts" @'
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common'
import { PrismaClient } from '@clinic/database'

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect()
  }

  async onModuleDestroy() {
    await this.$disconnect()
  }
}
'@

# UI package.json
Create-File "packages/ui/package.json" @'
{
  "name": "@clinic/ui",
  "version": "1.0.0",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch"
  },
  "peerDependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "tsup": "^7.2.0",
    "typescript": "^5.2.2"
  }
}
'@

# UI index.ts
Create-File "packages/ui/src/index.ts" @'
export const Button = () => null
export const Card = () => null
export const Input = () => null
export const Label = () => null
'@

# UI tsup config
Create-File "packages/ui/tsup.config.ts" @'
import { defineConfig } from 'tsup'

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  clean: true,
})
'@

# UI tsconfig.json
Create-File "packages/ui/tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "lib": ["DOM", "ESNext"],
    "jsx": "react",
    "declaration": true,
    "declarationMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
'@

# Shared package.json
Create-File "packages/shared/package.json" @'
{
  "name": "@clinic/shared",
  "version": "1.0.0",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch"
  },
  "devDependencies": {
    "tsup": "^7.2.0",
    "typescript": "^5.2.2"
  }
}
'@

# Shared index.ts
Create-File "packages/shared/src/index.ts" @'
export const constants = {
  APP_NAME: "Premium Clinic System",
  APP_VERSION: "1.0.0"
}
'@

# Shared tsup config
Create-File "packages/shared/tsup.config.ts" @'
import { defineConfig } from 'tsup'

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  clean: true,
})
'@

# Root tsconfig.json
Create-File "tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  }
}
'@

Write-Host "`n✅ All files created successfully!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Copy .env.example to .env and update values" -ForegroundColor Yellow
Write-Host "2. Run: npm install" -ForegroundColor Yellow
Write-Host "3. Run: docker-compose up -d" -ForegroundColor Yellow
Write-Host "4. Run: npm run db:migrate" -ForegroundColor Yellow
Write-Host "5. Run: npm run db:generate" -ForegroundColor Yellow
Write-Host "6. Run: npm run dev" -ForegroundColor Yellow