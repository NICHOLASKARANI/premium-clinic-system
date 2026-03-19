import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  console.log('Testing connection...')
  const result = await prisma.\SELECT 1 as test\
  console.log('Connection successful:', result)
}

main()
  .catch(console.error)
  .finally(() => prisma.())
