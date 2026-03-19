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
