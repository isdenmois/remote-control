import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { FilesModule } from './files/files.module';
import { SystemModule } from './system/system.module';
import { KeyboardModule } from './keyboard/keyboard.module';

@Module({
  imports: [ConfigModule.forRoot(), FilesModule, SystemModule, KeyboardModule],
})
export class AppModule { }
