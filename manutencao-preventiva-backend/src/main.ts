import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { json, urlencoded } from 'express';
import expressListRoutes from 'express-list-routes';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors();

  app.use(json({ limit: '50mb' }));
  app.use(urlencoded({ extended: true, limit: '50mb' }));

  const expressApp = app.getHttpAdapter().getInstance();
  expressListRoutes(expressApp);

  await app.listen(process.env.PORT ?? 3000);
}

bootstrap();
