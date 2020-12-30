import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { FilesModule } from './files/files.module';
import { SystemModule } from './system/system.module';
import { KeyboardModule } from './keyboard/keyboard.module';

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'web'),
    }),
    ConfigModule.forRoot(),
    FilesModule,
    SystemModule,
    KeyboardModule,
  ],
})
export class AppModule {}
