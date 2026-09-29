import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import expressListRoutes from 'express-list-routes';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors();

  const expressApp = app.getHttpAdapter().getInstance();
  expressListRoutes(expressApp);

  await app.listen(process.env.PORT ?? 3000);
}

bootstrap();
