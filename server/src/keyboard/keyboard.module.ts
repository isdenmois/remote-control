import { Module } from '@nestjs/common';
import { KeyboardController } from './keyboard.controller';
import { KeyboardService } from './keyboard.service';

@Module({
  controllers: [KeyboardController],
  providers: [KeyboardService],
})
export class KeyboardModule {}
